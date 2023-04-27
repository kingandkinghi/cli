cli::intrinsic::bash::array::pop () 
{ 
    (( $# > 0 )) || cli::assert 'Stack empty.';
    MAPFILE=(${@:1:$((${#@}-1))})
}
cli::intrinsic::bash::function::is_declared () 
{ 
    declare -F "${1-}" > /dev/null
}
cli::intrinsic::bash::function::list () 
{ 
    declare -F | awk '{ print $3 }' | cli::intrinsic::bash::filter::glob "$@"
}
cli::intrinsic::bash::printf () 
{ 
    local FORMAT=${1-};
    [[ -n "{FORMAT}" ]] || cli::assert 'Missing format.';
    shift;
    if (( $# == 0 )); then
        return;
    fi;
    printf "${FORMAT}" "$@"
}
cli::intrinsic::bash::variable::emit () 
{ 
    cli::intrinsic::bash::variable::list "$@" | while read; do
        declare -p ${REPLY};
    done
}
cli::intrinsic::cache::path () 
{ 
    cli::intrinsic::path::name "$1";
    local NAME="${REPLY}";
    cli::intrinsic::path::dir "$1";
    local DIR="${REPLY}";
    REPLY="${DIR}/.cli/${NAME}"
}
cli::intrinsic::cache::put () 
{ 
    local CACHE="$1";
    cli::intrinsic::path::dir "${CACHE}";
    local DIR="${REPLY}";
    mkdir -p "${DIR}";
    cli::intrinsic::temp::file;
    local TEMP="${REPLY}";
    cat > "${TEMP}";
    mv "${TEMP}" "${CACHE}";
    REPLY="${CACHE}"
}
cli::intrinsic::cache::test () 
{ 
    local CACHE="$1";
    shift;
    if [[ ! -f "${CACHE}" ]]; then
        return 1;
    fi;
    while (( $# > 0 )); do
        local SOURCE="$1";
        shift;
        if [[ ! "${SOURCE}" -ot "${CACHE}" ]]; then
            return 1;
        fi;
    done
}
cli::intrinsic::name::parse () 
{ 
    MAPFILE=();
    while [[ "${1-}" =~ ${CLI_REGEX_NAME} ]]; do
        MAPFILE+=("$1");
        shift;
    done
}
cli::intrinsic::name::to_function () 
{ 
    cli::intrinsic::name::to_bash "$@";
    cli::intrinsic::bash::join "::" "${MAPFILE[@]}"
}
cli::intrinsic::name::to_inline () 
{ 
    cli::intrinsic::name::to_bash "$@";
    cli::intrinsic::bash::join '::' "${MAPFILE[@]}"
}
cli::intrinsic::name::to_symbol () 
{ 
    cli::intrinsic::name::to_bash "$@";
    cli::intrinsic::bash::join '_' "${MAPFILE[@]^^}"
}
cli::intrinsic::path::dir () 
{ 
    REPLY="$(dirname $1)"
}
cli::intrinsic::run_as () 
{ 
    local -a args=($(printf %q "${arg_command}"));
    for i in "$@";
    do
        args+=($(printf %q "${i}"));
    done;
    sudo su "${arg_user}" -c "${args[*]}"
}
cli::intrinsic::set::deflower () 
{ 
    local -n SET_REF=${1?'Missing set'};
    local KEY=${2?'Missing element value'};
    if cli::intrinsic::set::test "$@"; then
        return 1;
    fi;
    SET_REF[${KEY}]=true
}
cli::intrinsic::set::test () 
{ 
    local -n SET_REF=${1:?'Missing set'};
    shift;
    local KEY="$*";
    [[ -n "${KEY}" ]] || cli::assert 'Missing key';
    [[ ${SET_REF[${KEY}]+hit} == 'hit' ]]
}
cli::intrinsic::shim::shebang () 
{ 
    local SOURCE_PATH_RELATIVE="${1-}";
    shift;
    cli::intrinsic::path::make_absolute "${SOURCE_PATH_RELATIVE}";
    local SOURCE_PATH="${REPLY}";
    [[ -n "${CLI_TOOL}" ]] || cli::assert "Shebang failed to declare 'CLI_TOOL'.";
    cli::intrinsic::shim::source "${CLI_TOOL}" || cli::assert "Shebang failed to find shim for cli '${CLI_TOOL}'.";
    local ROOT_DIR=$("${CLI_TOOL}" ---root);
    local REL_PATH="${SOURCE_PATH##"${ROOT_DIR}/"}";
    (( ${#REL_PATH} < ${#SOURCE_PATH} )) || cli::assert "Source path '${SOURCE_PATH}' is not a subpath of '${ROOT_DIR}'.";
    local IFS=/;
    local -a COMMAND=(${CLI_TOOL} ${REL_PATH});
    IFS=${CLI_IFS};
    set "${COMMAND[@]}" "$@";
    unset SOURCE_PATH_RELATIVE;
    unset SOURCE_PATH;
    unset REL_PATH;
    unset COMMAND;
    unset ROOT_DIR;
    [[ -v CLI_TOOL ]] || cli::assert;
    "$@"
}
cli::intrinsic::shim::source () 
{ 
    local NAME="${1-}";
    shift;
    [[ -n ${NAME} ]] || cli::assert 'Missing shim name.';
    if declare -F "${NAME}" > /dev/null; then
        return;
    fi;
    cli::intrinsic::bash::which "${NAME}" || cli::assert "Failed to find shim '${NAME}' on the path.";
    source "${REPLY}";
    cli::intrinsic::bash::function::is_declared "${NAME}" || cli::assert "Shim '${NAME}' failed to define function ${NAME}."
}
cli::intrinsic::shim::which () 
{ 
    local SHIM="${1-}";
    shift;
    cli::intrinsic::shim::source "${SHIM}" || return 1;
    local ROOT_DIR=$( ${SHIM} ---root );
    [[ -d "${ROOT_DIR}" ]] || cli::assert "Shim '${SHIM} ---root' returned '${ROOT_DIR}' which is not a directory.";
    MAPFILE=();
    local IFS=/;
    REPLY="${ROOT_DIR}/$*";
    MAPFILE+=("${REPLY}");
    if [[ ! -f "${REPLY}" ]]; then
        REPLY+='.sh';
        MAPFILE+=("${REPLY}");
    fi;
    [[ -f "${REPLY}" ]]
}
cli::intrinsic::stderr::assert () 
{ 
    if (( $# == 0 )); then
        set 'Condition failed';
    fi;
    { 
        echo "ASSERT FAILED:" "$*";
        cli::intrinsic::bash::stack::trace | sed 's/^/  /'
    } | cli::intrinsic::stderr::dump
}
cli::intrinsic::stderr::fail () 
{ 
    echo "$*" | cli::intrinsic::stderr::dump
}
cli::intrinsic::stderr::on_err () 
{ 
    local -a CLI_PIPESTATUS=("${PIPESTATUS[@]}");
    local CLI_TRAP_EXIT_CODE=${1-'?'};
    local BPID="${BASHPID}";
    if [[ ! $- =~ e ]]; then
        return;
    fi;
    { 
        echo -n "TRAP ERR: exit=${CLI_TRAP_EXIT_CODE}";
        if (( ${#CLI_PIPESTATUS[@]} > 1 )); then
            echo -n ", pipe=[$(cli::intrinsic::bash::join ',' "${CLI_PIPESTATUS[@]}")]";
        fi;
        echo ", bpid=${BPID}, pid=$$";
        echo "BASH_COMMAND ERR: ${BASH_COMMAND}";
        cli::intrinsic::bash::stack::trace | sed 's/^/  /'
    } | cli::intrinsic::stderr::dump
}
cli::intrinsic::bash::filter::glob () 
{ 
    while read -r; do
        local FILTER;
        for FILTER in "$@";
        do
            if [[ "${REPLY}" == ${FILTER} ]]; then
                echo "${REPLY}";
                break;
            fi;
        done;
    done
}
cli::intrinsic::bash::variable::list () 
{ 
    local NAME;
    for NAME in "$@";
    do
        if [[ ! -n "${NAME}" ]]; then
            continue;
        else
            if [[ "${NAME}" =~ ^.*[*]$ ]]; then
                local MATCH;
                for MATCH in $(eval "echo \${!${NAME}}");
                do
                    echo "${MATCH}";
                done;
            else
                if [[ -v "${NAME}" ]]; then
                    echo "${NAME}";
                else
                    local MATCH;
                    for MATCH in $(eval "echo \${!${NAME}*}");
                    do
                        if [[ "${MATCH}" == "${NAME}" ]]; then
                            echo "${NAME}";
                        fi;
                    done;
                fi;
            fi;
        fi;
    done | sort
}
cli::intrinsic::path::name () 
{ 
    REPLY="${1##*/}"
}
cli::intrinsic::temp::file () 
{ 
    local TEMP_FILE=$(mktemp "${1-"${TMPDIR:-/tmp/}"}cli-XXXXXXXX");
    declare -gA "CLI_SUBSHELL_TEMP_FILE_${BASHPID}+=()";
    local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
    if (( ${#CLI_SUBSHELL_TEMP_FILE_BASHPID[@]} == 0 )); then
        function cli::intrinsic::temp::file::on_exit () 
        { 
            local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
            cli::intrinsic::temp::remove "${!CLI_SUBSHELL_TEMP_FILE_BASHPID[@]}"
        };
        cli::intrinsic::subshell::on_exit cli::intrinsic::temp::file::on_exit;
    fi;
    CLI_SUBSHELL_TEMP_FILE_BASHPID+=(["${TEMP_FILE}"]='true');
    REPLY="${TEMP_FILE}"
}
cli::intrinsic::bash::join () 
{ 
    local DELIMITER=${1?'Missing delimiter'};
    shift;
    REPLY="";
    while (( $# > 0 )); do
        REPLY+="$1";
        shift;
        if (( $# > 0 )); then
            REPLY+="${DELIMITER}";
        fi;
    done
}
cli::intrinsic::name::to_bash () 
{ 
    MAPFILE=();
    while (( $# > 0 )); do
        [[ "$1" =~ ${CLI_REGEX_NAME} ]] || cli::assert "Unexpected cli name \"$1\" does not match regex ${CLI_REGEX_NAME}.";
        MAPFILE+=("${1//[-.]/_}");
        shift;
    done;
    REPLY=${MAPFILE[0]}
}
cli::intrinsic::path::make_absolute () 
{ 
    if [[ ! -n "${1-}" ]]; then
        REPLY="${PWD}";
    else
        if [[ ! "$1" =~ ^/ ]]; then
            REPLY="${PWD}/${1##./}";
        else
            REPLY="$1";
        fi;
    fi
}
cli::intrinsic::bash::which () 
{ 
    MAPFILE=();
    local NAME="$1";
    shift;
    local IFS=:;
    local -a DIRS=(${PATH});
    IFS="${CLI_IFS}";
    for dir in "${DIRS[@]}";
    do
        local PROBE="${dir}/${NAME}";
        MAPFILE+=("${PROBE}");
        cli::intrinsic::path::get_info "${PROBE}";
        if ${REPLY_CLI_PATH_IS_EXECUTABLE}; then
            REPLY="${PROBE}";
            return 0;
        fi;
    done;
    return 1
}
cli::intrinsic::bash::stack::trace () 
{ 
    cli::intrinsic::bash::stack::call;
    if [[ -n "${CLI_STACK_SHOW_PROCESS-}" ]]; then
        cli::intrinsic::bash::stack::process;
    fi
}
cli::intrinsic::stderr::dump () 
{ 
    cli::intrinsic::stderr::cat;
    cli::intrinsic::process::signal
}
cli::intrinsic::stderr::message () 
{ 
    local CHAR="$1";
    shift;
    local THOUSAND=1024;
    local INDEX;
    local THOUSAND_CHARS=$(
        for ((INDEX=0; INDEX<${THOUSAND}; INDEX++)); do 
            printf "${CHAR}"
        done
    );
    for ((INDEX=0; INDEX<${THOUSAND}; INDEX++))
    do
        { 
            echo ${THOUSAND_CHARS}
        };
    done
}
cli::intrinsic::subshell::on_exit () 
{ 
    local -ga "CLI_SUBSHELL_ON_EXIT_${BASHPID}+=()";
    local -n CLI_SUBSHELL_ON_EXIT=CLI_SUBSHELL_ON_EXIT_${BASHPID};
    if (( ${#CLI_SUBSHELL_ON_EXIT[@]} == 0 )); then
        function cli::intrinsic::subshell::on_exit::trap () 
        { 
            local -n CLI_SUBSHELL_ON_EXIT=CLI_SUBSHELL_ON_EXIT_${BASHPID};
            local DELEGATE;
            for DELEGATE in ${CLI_SUBSHELL_ON_EXIT[@]};
            do
                ${DELEGATE};
            done
        };
        trap cli::intrinsic::subshell::on_exit::trap EXIT;
    fi;
    CLI_SUBSHELL_ON_EXIT+=("$@")
}
cli::intrinsic::temp::remove () 
{ 
    local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
    for FILE in "$@";
    do
        if ! ${CLI_SUBSHELL_TEMP_FILE_BASHPID[${FILE}]-}; then
            continue;
        fi;
        unset "CLI_SUBSHELL_TEMP_FILE_BASHPID[${FILE}]";
        if [[ ! -a "${FILE}" ]]; then
            :;
        else
            if [[ -d "${FILE}" ]]; then
                rm -f -r "${FILE}";
                rm -f -r "${FILE}";
            else
                rm -f "${FILE}";
            fi;
        fi;
    done
}
cli::intrinsic::path::get_info () 
{ 
    REPLY_CLI_PATH_EXISTS=false;
    REPLY_CLI_PATH_IS_FILE=false;
    REPLY_CLI_PATH_IS_DIRECTORY=false;
    REPLY_CLI_PATH_IS_EXECUTABLE=false;
    REPLY_CLI_PATH_IS_WRITABLE=false;
    REPLY_CLI_PATH_IS_SYMBOLIC_LINK=false;
    if [[ ! -n "${1-}" || ! -e "${1}" ]]; then
        return;
    fi;
    REPLY_CLI_PATH_EXISTS=true;
    if [[ -f "${1}" ]]; then
        REPLY_CLI_PATH_IS_FILE=true;
    else
        if [[ -d "${1}" ]]; then
            REPLY_CLI_PATH_IS_DIRECTORY=true;
        else
            if [[ -L "${1}" ]]; then
                REPLY_CLI_PATH_IS_SYMBOLIC_LINK=true;
            fi;
        fi;
    fi;
    if [[ -w "${1}" ]]; then
        REPLY_CLI_PATH_IS_WRITABLE=true;
    fi;
    if [[ -x "${1}" ]]; then
        REPLY_CLI_PATH_IS_EXECUTABLE=true;
    fi
}
cli::intrinsic::bash::stack::call () 
{ 
    set -- ${BASH_ARGV[@]};
    local -i argc=0;
    for ((i=0; i<${#FUNCNAME[@]}; i++ ))
    do
        local -a args=();
        local inline_args='';
        local funcname="${FUNCNAME[$i]}";
        if (( i == ${#FUNCNAME[@]}-1 )); then
            funcname='bash::main';
        fi;
        for ((j=${BASH_ARGC[$i]}-1; j>=0; j-- ))
        do
            args+=("$(cli::intrinsic::bash::literal "${BASH_ARGV[${j}+${argc}]}")");
        done;
        argc+=${BASH_ARGC[$i]};
        if [[ ! -n "${CLI_STACK_SHOW_HIDDEN-}" ]] && cli::intrinsic::attribute::is_defined 'METHOD' "${funcname}" 'cli_bash_stack_hidden_attribute'; then
            continue;
        fi;
        inline_args="${args[@]}";
        if (( ${#inline_args} > 80 )); then
            inline_args=;
        else
            args=();
        fi;
        printf '%-50s %s:%s\n' "${funcname} ${inline_args}" "${BASH_SOURCE[$i]}" ${BASH_LINENO[$i-1]-};
        for arg in "${args[@]}";
        do
            echo "${arg}";
        done | sed 's/^/  /';
    done
}
cli::intrinsic::bash::stack::process () 
{ 
    local ARG_START_PID=${1-$$};
    local ARG_END_PID=${2-${CLI_PID-}};
    local -a pid_parent=();
    local -a pid_cmd=();
    while read pid ppid cmd; do
        pid_parent[${pid}]=${ppid};
        pid_cmd[${pid}]="${cmd}";
    done < <(ps -o pid=,ppid=,args=);
    local pid=${BASHPID};
    local -a subshell=(${BASHPID});
    while (( $pid != $$ )); do
        echo "(${pid}) subshell";
        pid=${pid_parent[${pid}]};
    done;
    local pid=${ARG_START_PID};
    for ((i=0; ${pid} > 0; i++ ))
    do
        echo -n "(${pid}) ";
        local inline_args=${pid_cmd[${pid}]};
        if (( ${#inline_args} < 80 )); then
            echo "${inline_args}";
        else
            echo "${inline_args}" | sed -e 's/--/\
  --/g';
        fi;
        if (( ${pid} == ${ARG_END_PID-0} )); then
            break;
        fi;
        pid=${pid_parent[${pid}]-0};
    done
}
cli::intrinsic::stderr::cat () 
{ 
    cli::intrinsic::temp::file;
    local SCRATCH="${REPLY}";
    cat > "${SCRATCH}";
    cat "${SCRATCH}" | cli::intrinsic::stderr::lock 1>&2;
    rm "${SCRATCH}"
}
cli::intrinsic::process::signal () 
{ 
    local SIGNAL=${1-SIGINT};
    cli::intrinsic::process::get_info;
    kill "-${SIGNAL}" "-${REPLY_CLI_PROCESS_GROUP_ID}"
}
cli::intrinsic::attribute::is_defined () 
{ 
    local target_type=${1-};
    shift;
    local target=${1-};
    shift;
    local type=${1-};
    shift;
    [[ ${target_type} == 'METHOD' ]] || cli::assert;
    [[ ${target} != 'METHOD' ]] || [[ ${target} =~ ${CLI_REGEX_BASH_NAME} ]] || cli::assert;
    local -n targets="CLI_META_ATTRIBUTES_${target_type}";
    local index=${targets[${target}]:-};
    local -n ref="CLI_META_ATTRIBUTES_${target_type}_${index}_TYPE";
    for attribute in "${ref[@]}";
    do
        if [[ "${attribute}" == "${type}" ]]; then
            return 0;
        fi;
    done;
    return 1
}
cli::intrinsic::bash::literal () 
{ 
    local literal="$*";
    if [[ "${literal}" =~ ^[a-zA-Z0-9_-]*$ ]]; then
        echo "${literal}";
        return 0;
    fi;
    local ARRAY=("$*");
    literal=$(declare -p ARRAY);
    literal="${literal:22}";
    literal="${literal:0: -1}";
    echo "${literal}"
}
cli::intrinsic::stderr::lock () 
{ 
    flock -x "${CLI_LOADER_LOCK}" cat
}
cli::intrinsic::process::get_info () 
{ 
    local PID="${1-${BASHPID}}";
    REPLY_CLI_PROCESS_ID=;
    REPLY_CLI_PROCESS_PARENT_ID=;
    REPLY_CLI_PROCESS_GROUP_ID=;
    REPLY_CLI_PROCESS_TERMINAL_ID=;
    REPLY_CLI_PROCESS_USER_ID=;
    REPLY_CLI_PROCESS_UTILIZATION=;
    REPLY_CLI_PROCESS_COMMAND=;
    REPLY_CLI_PROCESS_ARGS=;
    read REPLY_CLI_PROCESS_ID REPLY_CLI_PROCESS_PARENT_ID REPLY_CLI_PROCESS_GROUP_ID REPLY_CLI_PROCESS_TERMINAL_ID REPLY_CLI_PROCESS_USER_ID REPLY_CLI_PROCESS_UTILIZATION REPLY_CLI_PROCESS_COMMAND REPLY_CLI_PROCESS_ARGS < <(ps -p "${PID}" -o pid=,ppid=,pgid=,tname=,euid=,pcpu=,ucmd=,args=)
}
