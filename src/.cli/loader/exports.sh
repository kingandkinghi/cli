set -ehuBET

declare -r CLI_IFS=" 	
"
declare -gx LC_ALL=POSIX

shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s extdebug
shopt -s extglob
shopt -s extquote
shopt -s force_fignore
shopt -s globasciiranges
shopt -s globstar
shopt -s hostcomplete
shopt -s inherit_errexit
shopt -s interactive_comments
shopt -s lastpipe
shopt -s nullglob
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath
shopt -u assoc_expand_once
shopt -u autocd
shopt -u cdable_vars
shopt -u cdspell
shopt -u checkhash
shopt -u checkjobs
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u compat42
shopt -u compat43
shopt -u compat44
shopt -u direxpand
shopt -u dirspell
shopt -u dotglob
shopt -u execfail
shopt -u expand_aliases
shopt -u failglob
shopt -u gnu_errfmt
shopt -u histappend
shopt -u histreedit
shopt -u histverify
shopt -u huponexit
shopt -u lithist
shopt -u localvar_inherit
shopt -u localvar_unset
shopt -u login_shell
shopt -u mailwarn
shopt -u nocaseglob
shopt -u nocasematch
shopt -u no_empty_cmd_completion
shopt -u progcomp_alias
shopt -u restricted_shell
shopt -u shift_verbose
shopt -u xpg_echo

declare -a CLI_COMMAND_STACK=()
declare -A CLI_LOADER_CACHE_COVERED=(["cli loader"]="true" )
declare -A CLI_LOADER_CACHE_IMPORTED=(["cli loader"]="true" ["cli .group"]="true" )
declare -A CLI_LOADER_CACHE_SOURCED_PATHS=([/workspaces/cli/src/loader]="true" )
declare -a CLI_LOADER_CLI_LOADER_IMPORT=()
declare -A CLI_SCOPE=()
declare -Ag CLI_META_ATTRIBUTES_METHOD=()
declare -Ar CLI_LOADER_KNOWN_COMMANDS=(["cli dsl meta"]="" ["cli dsl build"]="" ["cli loader"]="" ["cli dsl parse"]="" ["cli dsl tokenize"]="" )
declare -arg CLI_ARG_PRODUCTION=([0]="SEGMENT" [1]="OPTION" [2]="POSITIONAL")
declare -arg CLI_ARG_TOKEN=([0]="PATH" [1]="VALUE" [2]="DASH" [3]="DASH_DASH" [4]="DASH_DASH_DASH" [5]="END_OPTIONS" [6]="EOF")
declare -arg CLI_META_ATTRIBUTES_METHOD_0_BLOB=()
declare -arg CLI_META_ATTRIBUTES_METHOD_0_TYPE=([0]="cli_bash_stack_hidden_attribute")
declare -Arg CLI_TYPE_CLI_ARGS=([named]="map_of array" [positional]="array" )
declare -Arg CLI_TYPE_CLI_HELP_PARSE=([group]="map_of cli_help_parse_group" )
declare -Arg CLI_TYPE_CLI_HELP_PARSE_GROUP=([type]="map" [alias]="map" [regex]="map" [positional]="boolean" [require]="map" [default]="map" [allow]="map_of map" )
declare -Arg CLI_TYPE_CLI_META_ATTRIBUTES=([method]="map_of cli_meta_attribute" )
declare -Arg CLI_TYPE_CLI_META_ATTRIBUTE=([type]="array" [blob]="array" )
declare -Arg CLI_TYPE_CLI_META=([group]="map_of cli_meta_group" [alias]="map" )
declare -Arg CLI_TYPE_CLI_META_GROUP=([type]="map" [regex]="map" [positional]="boolean" [require]="map" [default]="map" [allow]="map_of map" )
declare -Arg CLI_TYPE_CLI_TOKENS=([identifier]="array" [id]="array" )
declare -r CLI_LOADER_CLI_LOADER_SOURCE="/workspaces/cli/src/loader"
declare -r CLI_LOADER_LOCK="/tmp/.cli_lock"
declare -rg CLI_ARG_PRODUCTION_OPTION="1"
declare -rg CLI_ARG_PRODUCTION_POSITIONAL="2"
declare -rg CLI_ARG_PRODUCTION_SEGMENT="0"
declare -rg CLI_ARG_TOKEN_DASH="2"
declare -rg CLI_ARG_TOKEN_DASH_DASH="3"
declare -rg CLI_ARG_TOKEN_DASH_DASH_DASH="4"
declare -rg CLI_ARG_TOKEN_END_OPTIONS="5"
declare -rg CLI_ARG_TOKEN_EOF="6"
declare -rg CLI_ARG_TOKEN_PATH="0"
declare -rg CLI_ARG_TOKEN_VALUE="1"
declare -rg CLI_REGEX_BASH_FUNCTION="^[:a-z_][:a-z0-9_]*$"
declare -rg CLI_REGEX_BASH_NAME="^[a-z_][a-z0-9_]*$"
declare -rg CLI_REGEX_GLOBAL_NAME="^[A-Z][A-Z0-9_]*$"
declare -rg CLI_REGEX_NAME="^[a-z.][a-z0-9-]*$"
declare -rg CLI_REGEX_PROPERTY_ARG="^([a-z.][a-z0-9-]*)=(.*)$"
declare -rg CLI_REGEX_STRUCT_FIELD_NAME="^[a-z][a-z0-9_]*$"
declare -rg CLI_REGEX_STRUCT_NAME="^[a-z][a-z0-9_]*$"
declare -rg CLI_REGEX_TYPE_NAME="^(map_of[[:space:]])*[a-z][a-z0-9_]*$"
declare -rg CLI_REGEX_VARIABLE_NAME="^[a-z][a-z0-9_]*$"

# TOC of cli::*
# cli::assert
# cli::dump
# cli::export
# cli::intrinsic::attribute::is_defined
# cli::intrinsic::bash::array::pop
# cli::intrinsic::bash::filter::glob
# cli::intrinsic::bash::function::is_declared
# cli::intrinsic::bash::function::list
# cli::intrinsic::bash::join
# cli::intrinsic::bash::literal
# cli::intrinsic::bash::printf
# cli::intrinsic::bash::stack::call
# cli::intrinsic::bash::stack::process
# cli::intrinsic::bash::stack::trace
# cli::intrinsic::bash::variable::emit
# cli::intrinsic::bash::variable::list
# cli::intrinsic::bash::which
# cli::intrinsic::cache::path
# cli::intrinsic::cache::put
# cli::intrinsic::cache::test
# cli::intrinsic::name::parse
# cli::intrinsic::name::to_bash
# cli::intrinsic::name::to_function
# cli::intrinsic::name::to_inline
# cli::intrinsic::name::to_symbol
# cli::intrinsic::path::dir
# cli::intrinsic::path::get_info
# cli::intrinsic::path::make_absolute
# cli::intrinsic::path::name
# cli::intrinsic::process::get_info
# cli::intrinsic::process::signal
# cli::intrinsic::run_as
# cli::intrinsic::set::deflower
# cli::intrinsic::set::test
# cli::intrinsic::shim::shebang
# cli::intrinsic::shim::source
# cli::intrinsic::shim::which
# cli::intrinsic::stderr::assert
# cli::intrinsic::stderr::cat
# cli::intrinsic::stderr::dump
# cli::intrinsic::stderr::fail
# cli::intrinsic::stderr::lock
# cli::intrinsic::stderr::message
# cli::intrinsic::stderr::on_err
# cli::intrinsic::subshell::on_exit
# cli::intrinsic::temp::file
# cli::intrinsic::temp::remove
# cli::loader::backpatch
# cli::loader::cache::path
# cli::loader::cache::test
# cli::loader::declare
# cli::loader::declare::cache
# cli::loader::declare::entry_points
# cli::loader::declare::group
# cli::loader::declare::name
# cli::loader::declare::source
# cli::loader::declare::type
# cli::loader::emit::function
# cli::loader::emit::functions
# cli::loader::emit::imports
# cli::loader::emit::inline
# cli::loader::emit::variables
# cli::loader::exports::source
# cli::loader::function::list
# cli::loader::help
# cli::loader::help::extended
# cli::loader::help::global
# cli::loader::import
# cli::loader::import_parent
# cli::loader::main
# cli::loader::main::command
# cli::loader::main::command::dispatch
# cli::loader::main::command::known
# cli::loader::main::command::load
# cli::loader::main::cover
# cli::loader::main::dispatch
# cli::loader::main::group
# cli::loader::main::help
# cli::loader::main::imports
# cli::loader::main::inline
# cli::loader::main::invoke
# cli::loader::main::shim
# cli::loader::self_test
# cli::loader::shim
# cli::loader::source
# cli::loader::variable::list
# cli::source

cli::assert () 
{ 
    cli::intrinsic::stderr::assert "$@"
}
cli::dump () 
{ 
    cli::intrinsic::bash::variable::emit "$@"
}
cli::export () 
{ 
    cli::loader::emit::variables "$@";
    cli::loader::emit::functions "$@"
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
cli::intrinsic::bash::array::pop () 
{ 
    (( $# > 0 )) || cli::assert 'Stack empty.';
    MAPFILE=(${@:1:$((${#@}-1))})
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
cli::intrinsic::bash::function::is_declared () 
{ 
    declare -F "${1-}" > /dev/null
}
cli::intrinsic::bash::function::list () 
{ 
    declare -F | awk '{ print $3 }' | cli::intrinsic::bash::filter::glob "$@"
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
cli::intrinsic::bash::stack::trace () 
{ 
    cli::intrinsic::bash::stack::call;
    if [[ -n "${CLI_STACK_SHOW_PROCESS-}" ]]; then
        cli::intrinsic::bash::stack::process;
    fi
}
cli::intrinsic::bash::variable::emit () 
{ 
    cli::intrinsic::bash::variable::list "$@" | while read; do
        declare -p ${REPLY};
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
cli::intrinsic::path::name () 
{ 
    REPLY="${1##*/}"
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
cli::intrinsic::process::signal () 
{ 
    local SIGNAL=${1-SIGINT};
    cli::intrinsic::process::get_info;
    kill "-${SIGNAL}" "-${REPLY_CLI_PROCESS_GROUP_ID}"
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
cli::intrinsic::stderr::cat () 
{ 
    cli::intrinsic::temp::file;
    local SCRATCH="${REPLY}";
    cat > "${SCRATCH}";
    cat "${SCRATCH}" | cli::intrinsic::stderr::lock 1>&2;
    rm "${SCRATCH}"
}
cli::intrinsic::stderr::dump () 
{ 
    cli::intrinsic::stderr::cat;
    cli::intrinsic::process::signal
}
cli::intrinsic::stderr::fail () 
{ 
    echo "$*" | cli::intrinsic::stderr::dump
}
cli::intrinsic::stderr::lock () 
{ 
    flock -x "${CLI_LOADER_LOCK}" cat
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
cli::loader::backpatch () 
{ 
    cli::intrinsic::name::to_inline "${CLI_COMMAND[@]}";
    set "${REPLY}";
    cli::intrinsic::bash::function::is_declared "$1" || cli::assert "No stub '$1' found to backpatch.";
    unset -f "$1";
    cli::loader::exports::source;
    cli::intrinsic::bash::function::is_declared "$1" || cli::assert "Failed to backpatch stub '$1'.";
    cli::loader::main::cover
}
cli::loader::cache::path () 
{ 
    REPLY="${CLI_CACHE}/$1"
}
cli::loader::cache::test () 
{ 
    cli::loader::cache::path "$@";
    cli::intrinsic::cache::test "${REPLY}" "${CLI_SOURCE}" "${CLI_LOADER_CLI_LOADER_SOURCE}"
}
cli::loader::declare () 
{ 
    cli::loader::declare::group;
    cli::loader::declare::name;
    cli::loader::declare::source;
    cli::loader::declare::type "${CLI_NAME}" "${CLI_SOURCE}";
    cli::loader::declare::cache "${CLI_SOURCE}";
    cli::loader::declare::entry_points "${CLI_GROUP}" "${CLI_TYPE}"
}
cli::loader::declare::cache () 
{ 
    local SOURCE="$1";
    cli::intrinsic::cache::path "${SOURCE}";
    [[ ! -v CLI_CACHE ]] || cli::assert;
    CLI_CACHE="${REPLY}"
}
cli::loader::declare::entry_points () 
{ 
    local GROUP="$1";
    local TYPE="$2";
    if [[ ${TYPE} == group ]]; then
        cli::intrinsic::name::to_function ${GROUP};
    else
        cli::intrinsic::name::to_function "${CLI_COMMAND[@]}";
    fi;
    [[ ! -v CLI_FUNCTION_MAIN ]] || cli::assert;
    CLI_FUNCTION_MAIN="${REPLY}::main";
    [[ ! -v CLI_FUNCTION_INLINE ]] || cli::assert;
    CLI_FUNCTION_INLINE="${REPLY}";
    [[ ! -v CLI_FUNCTION_SELF_TEST ]] || cli::assert;
    CLI_FUNCTION_SELF_TEST="${REPLY}::self_test";
    [[ ! -v CLI_FUNCTION_HELP ]] || cli::assert;
    CLI_FUNCTION_HELP="${REPLY}::help"
}
cli::loader::declare::group () 
{ 
    [[ ! -v CLI_GROUP ]] || cli::assert;
    CLI_GROUP="${CLI_COMMAND[@]: 0: $(( ${#CLI_COMMAND[@]} -1 )) }"
}
cli::loader::declare::name () 
{ 
    [[ ! -v CLI_NAME ]] || cli::assert;
    CLI_NAME=${CLI_COMMAND[@]: -1}
}
cli::loader::declare::source () 
{ 
    cli::intrinsic::shim::which "${CLI_COMMAND[@]}" || cli::assert "Failed to find source for '${CLI_COMMAND[@]}'. Probed ${MAPFILE[@]}";
    [[ ! -v CLI_SOURCE ]] || cli::assert;
    CLI_SOURCE="${REPLY}"
}
cli::loader::declare::type () 
{ 
    local NAME="$1";
    local SOURCE="$2";
    [[ ! -v CLI_TYPE ]] || cli::assert;
    if [[ "${NAME}" == '.group' ]]; then
        CLI_TYPE=group;
    else
        if [[ "${SOURCE}" == *.sh ]]; then
            CLI_TYPE=inline;
        else
            CLI_TYPE=command;
        fi;
    fi
}
cli::loader::emit::function () 
{ 
    local FUNCTION="$1";
    shift;
    declare -f "${FUNCTION}"
}
cli::loader::emit::functions () 
{ 
    cli::loader::function::list "$@" | while read; do
        cli::loader::emit::function "${REPLY}";
    done
}
cli::loader::emit::imports () 
{ 
    cli::intrinsic::bash::printf 'cli::source %s\n' "$@"
}
cli::loader::emit::inline () 
{ 
    local FUNCTION="$1";
    shift;
    local -n IMPORTS="$1";
    shift;
    cli::loader::emit::imports "${IMPORTS[@]}";
    cli::loader::emit::function ${FUNCTION}
}
cli::loader::emit::variables () 
{ 
    local DECLARE FLAGS VALUE;
    cli::loader::variable::list "$@" | while read DECLARE FLAGS VALUE; do
        echo "declare ${FLAGS}g ${VALUE}";
    done
}
cli::loader::exports::source () 
{ 
    if ! cli::loader::cache::test 'exports.sh'; then
        ( ${CLI_COMMAND[@]} ---exports > /dev/null );
    fi;
    cli::loader::cache::path 'exports.sh';
    cli::loader::source "${REPLY}"
}
cli::loader::function::list () 
{ 
    local GLOB;
    for i in "$@";
    do
        GLOB+="${i}::";
    done;
    GLOB+='*';
    cli::intrinsic::bash::function::list "${GLOB}"
}
cli::loader::help () 
{ 
    cat <<-EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Loader library.
EOF

}
cli::loader::help::extended () 
{ 
    cli::loader::help::global;
    echo;
    echo 'Loader Arguments';
    echo '    ---help          [Flag] : Show extened help.';
    echo '    ---env           [Flag] : Dump script environment variables.';
    echo '    ---imports       [Flag] : List imported libraries.';
    echo '    ---variables     [Flag] : Dump command specific constants.';
    echo '    ---type          [Flag] : Print command type (command, inline, or group).';
    echo '    ---which         [Flag] : Print path to command file.';
    echo '    ---cache         [Flag] : Print path to command cache directory.';
    echo '    ---print         [Flag] : Print command file.';
    echo '    ---source        [Flag] : Source the command as if it were a library.';
    echo '    ---backpatch     [Flag] : ...';
    echo '    ---exports       [Flag] : Print path to library source.';
    echo '    ---dependencies  [Flag] : ....';
    echo '    ---tokenize      [Flag] : ....';
    echo '    ---parse         [Flag] : ....';
    echo '    ---meta          [Flag] : ....';
    echo '    ---load          [Flag] : ....';
    echo '    ---build         [Flag] : ....';
    echo '    ---args-tokenize [Flag] : ....';
    echo '    ---args-load     [Flag] : ....';
    echo '    ---args          [Flag] : ....';
    echo '    ---read          [Flag] : ....'
}
cli::loader::help::global () 
{ 
    echo;
    echo 'Global Arguments';
    echo '    --help -h        [Flag] : Show this message and exit.';
    echo '    --self-test      [Flag] : Runs a self test.'
}
cli::loader::import () 
{ 
    if ! cli::intrinsic::set::deflower CLI_LOADER_CACHE_IMPORTED "${CLI_COMMAND[*]}"; then
        return;
    fi;
    if [[ "${CLI_COMMAND[@]}" == 'cli loader' ]]; then
        return;
    fi;
    cli::loader::import_parent;
    cli::intrinsic::name::to_inline "${CLI_COMMAND[@]}";
    local FUNCTION=${REPLY};
    if cli::intrinsic::bash::function::is_declared "${FUNCTION}"; then
        return;
    fi;
    if [[ ${CLI_TYPE} == inline ]]; then
        eval "${FUNCTION}() { ${CLI_COMMAND[@]} ---backpatch; ${FUNCTION} \"\$@\"; }";
        cli::intrinsic::bash::function::is_declared "${FUNCTION}" || cli::assert;
        return;
    fi;
    if [[ ! -f "${CLI_SOURCE}" ]]; then
        [[ ${CLI_TYPE} == group ]] || cli::assert;
        return;
    fi;
    cli::loader::exports::source
}
cli::loader::import_parent () 
{ 
    local COMMAND=("${CLI_COMMAND[@]}");
    if (( ${#COMMAND[@]} < 2 )); then
        return;
    fi;
    if [[ "${COMMAND[@]: -1}" == '.group' ]]; then
        if (( ${#COMMAND[@]} == 2 )); then
            return;
        fi;
        COMMAND=("${COMMAND[@]:0:$(( ${#COMMAND[@]}-1 ))}");
    fi;
    COMMAND=("${COMMAND[@]:0:$(( ${#COMMAND[@]}-1 ))}" '.group');
    if cli::intrinsic::set::test CLI_LOADER_CACHE_IMPORTED "${COMMAND[*]}"; then
        return;
    fi;
    cli::intrinsic::bash::array::pop "${COMMAND[@]}";
    if ! diff <( cli::loader::emit::variables "${MAPFILE[@]}" ) - < /dev/null > /dev/null; then
        echo "Attempt to import '${COMMAND[@]}' but variables already defined:" 1>&2;
        cli::loader::emit::variables "${MAPFILE[@]}" | sed 's/^/  /' 1>&2;
        cli::assert "${MAPFILE[@]}";
    fi;
    "${COMMAND[@]}" ---source
}
cli::loader::main () 
{ 
    echo "set -$-";
    echo;
    declare -p CLI_IFS;
    echo declare -gx LC_ALL=POSIX;
    echo;
    shopt -p | sort -k2 -k3;
    echo;
    { 
        ( CLI_COMMAND_STACK=();
        CLI_SCOPE=();
        declare -p CLI_COMMAND_STACK;
        declare -p CLI_SCOPE );
        declare -p CLI_LOADER_KNOWN_COMMANDS;
        declare -p CLI_LOADER_LOCK;
        declare -p CLI_LOADER_CACHE_IMPORTED;
        declare -p CLI_LOADER_CACHE_COVERED;
        declare -p CLI_LOADER_CACHE_SOURCED_PATHS;
        declare -p CLI_LOADER_CLI_LOADER_SOURCE;
        declare -p CLI_LOADER_CLI_LOADER_IMPORT;
        cli::loader::emit::variables cli core;
        cli::loader::emit::variables cli regex;
        cli::loader::emit::variables cli known;
        cli::loader::emit::variables cli type;
        cli::loader::emit::variables cli bgen;
        cli::loader::emit::variables cli arg;
        cli::loader::emit::variables cli meta attributes
    } | sort -k2 -k3;
    echo;
    echo '# TOC of cli::*';
    cli::loader::function::list cli | sed 's/^/# /';
    echo;
    cli::loader::emit::functions cli;
    echo;
    trap -p;
    echo
}
cli::loader::main::command () 
{ 
    if [[ "${1-}" == ---* ]]; then
        while true; do
            case "$1" in 
                '---tokenize')
                    cli::loader::main::dispatch -h | cli dsl tokenize
                ;;
                '---parse')
                    ${CLI_COMMAND[@]} ---tokenize | cli dsl parse
                ;;
                '---meta')
                    ${CLI_COMMAND[@]} ---parse | cli dsl meta
                ;;
                '---load')
                    ${CLI_COMMAND[@]} ---meta | cli dsl load --
                ;;
                '---build')
                    cli::loader::main::dispatch -h | ARG_SCOPE=CLI_SCOPE cli dsl build -- "${CLI_META}"
                ;;
                *)
                    break
                ;;
            esac;
            return;
        done;
    fi;
    if cli::intrinsic::set::test CLI_LOADER_KNOWN_COMMANDS "${CLI_COMMAND[*]}"; then
        cli::loader::main::command::known "$@";
        return;
    fi;
    cli::loader::main::command::load;
    ARG_SCOPE=CLI_SCOPE cli::core::parse CLI_META "$@";
    local CLI_META_GROUP="${REPLY}";
    local -A CLI_SCOPE_LAST=();
    local -n CLI_META_GROUP_TYPE="${CLI_META_GROUP}_TYPE";
    for REPLY in "${!CLI_META_GROUP_TYPE[@]}";
    do
        local NAME="${REPLY}";
        cli::intrinsic::name::to_symbol "${NAME}";
        local VARIABLE="ARG_${REPLY}";
        local TYPE="${CLI_META_GROUP_TYPE[${NAME}]}";
        cli::core::type::to_bash "${TYPE}";
        local FLAGS="${REPLY}";
        local -${FLAGS} "${VARIABLE}";
        CLI_SCOPE_LAST["${VARIABLE}"]=CLI_SCOPE["${VARIABLE}"];
        CLI_SCOPE["${VARIABLE}"]="${TYPE}";
        if cli::intrinsic::set::test REPLY_CLI_PARSE_ARGS_NAMED ${NAME}; then
            local -n VARIABLE_REF=${VARIABLE};
            local -n VALUE_REF="REPLY_CLI_PARSE_ARGS_NAMED_${REPLY_CLI_PARSE_ARGS_NAMED[${NAME}]}";
            case ${TYPE} in 
                'array')
                    VARIABLE_REF=("${VALUE_REF[@]}")
                ;;
                'map')
                    local PAIR;
                    for PAIR in "${VALUE_REF[@]}";
                    do
                        VARIABLE_REF["${PAIR%%=*}"]="${PAIR#*=}";
                    done
                ;;
                *)
                    VARIABLE_REF="${VALUE_REF}"
                ;;
            esac;
        else
            ARG_SCOPE=CLI_SCOPE cli::core::variable::initialize "${VARIABLE}";
        fi;
    done;
    unset TYPE NAME VARIABLE FLAGS PAIR;
    unset -n VARIABLE_REF VALUE_REF;
    cli::loader::main::command::dispatch "${REPLY_CLI_ARGS_PARSE_POSITIONAL[@]}";
    for REPLY in "${!CLI_SCOPE_LAST[@]}";
    do
        CLI_SCOPE["${REPLY}"]=CLI_SCOPE_LAST["${REPLY}"];
    done
}
cli::loader::main::command::dispatch () 
{ 
    while [[ "${1-}" == ---* ]]; do
        case "$1" in 
            '---args-tokenize')

            ;;
            '---args-load')

            ;;
            '---args')
                cli::dump 'ARG_*'
            ;;
            '---read')
                shift;
                while read -a REPLY; do
                    ${CLI_FUNCTION_MAIN} "$@" "${REPLY[@]}";
                done
            ;;
            *)
                cli::intrinsic::stderr::fail "Unexpected unknown internal option \"$1\"."
            ;;
        esac;
        return;
    done;
    if [[ -n "${ARG_RUN_AS-}" ]] && [[ ! "${ARG_RUN_AS}" == "$(whoami)" ]]; then
        arg_user="${ARG_RUN_AS}" arg_command="$0" cli::intrinsic::run_as "$@";
        return;
    fi;
    cli::loader::main::invoke ${CLI_FUNCTION_MAIN} "$@"
}
cli::loader::main::command::known () 
{ 
    ARG_HELP=false;
    ARG_SELF_TEST=false;
    if (( $# > 0 )); then
        [[ ! "${CLI_COMMAND[*]}" == 'cli loader' ]] || cli::assert "Command 'cli loader' takes no arguments.";
        [[ "$1" == '--' ]] || cli::assert "Known command '${CLI_COMMAND[@]}' cannot have named arguments.";
        shift;
    fi;
    cli::loader::main::command::dispatch "$@"
}
cli::loader::main::command::load () 
{ 
    if cli::loader::cache::test 'meta.sh'; then
        cli::loader::source "${REPLY}";
        return;
    fi;
    local META_SH="${REPLY}";
    mkdir -p "${CLI_CACHE}";
    local HELP="${CLI_CACHE}/help";
    local TOKENIZE="${CLI_CACHE}/tokenize";
    local PARSE="${CLI_CACHE}/parse";
    local META="${CLI_CACHE}/meta";
    local LOAD="${CLI_CACHE}/load";
    if [[ -f "${META_SH}" && -f "${HELP}" ]] && diff "${HELP}" <( cli::loader::main::dispatch -h ) > /dev/null; then
        cli::loader::source "${META_SH}";
        return;
    fi;
    cli::loader::main::dispatch -h | ARG_SCOPE=CLI_SCOPE ARG_CLI_DSL_DECLARE_HELP="${HELP}" ARG_CLI_DSL_DECLARE_TOKENIZE="${TOKENIZE}" ARG_CLI_DSL_DECLARE_PARSE="${PARSE}" ARG_CLI_DSL_DECLARE_META="${META}" ARG_CLI_DSL_DECLARE_LOAD="${LOAD}" cli dsl build -- "${CLI_META}" | cli::intrinsic::cache::put "${META_SH}";
    cli::loader::source "${META_SH}"
}
cli::loader::main::cover () 
{ 
    if ! cli::intrinsic::set::deflower CLI_LOADER_CACHE_COVERED "${CLI_COMMAND[*]}"; then
        return;
    fi;
    for REPLY in "${CLI_IMPORT[@]}";
    do
        set ${REPLY};
        cli::intrinsic::shim::source "$1" || cli::assert "Failed to find shim '$1' for import of '$*'.";
        "$@" ---source;
    done
}
cli::loader::main::dispatch () 
{ 
    [[ -v CLI_TOOL ]] || cli::assert;
    [[ -v CLI_TYPE ]] || cli::assert;
    [[ -v CLI_COMMAND ]] || cli::assert;
    if cli::loader::main::help "$@"; then
        return;
    fi;
    if [[ "${1-}" == '--self-test' ]]; then
        cli::loader::main::invoke "${CLI_FUNCTION_SELF_TEST}";
        return;
    fi;
    if [[ "${CLI_TYPE}" == 'inline' ]]; then
        cli::loader::main::inline "$@";
    else
        if [[ "${CLI_TYPE}" == 'group' ]]; then
            cli::loader::main::group "$@";
        else
            [[ "${CLI_TYPE}" == 'command' ]] || cli::assert;
            cli::loader::main::command "$@";
        fi;
    fi
}
cli::loader::main::group () 
{ 
    [[ "${CLI_COMMAND[@]: -1}" == '.group' ]] || cli::assert;
    if [[ "${1-}" == '-l' ]]; then
        cli::intrinsic::path::dir "${CLI_SOURCE}";
        cli list --dir "${REPLY}";
        return;
    fi;
    (( $# == 0 )) || cli::assert "Unexpected arguments passed to '${CLI_COMMAND[*]}': $@";
    if cli::loader::cache::test 'exports.sh'; then
        cat "${REPLY}";
        return;
    fi;
    cli::loader::main::invoke "${CLI_FUNCTION_MAIN}" "$@"
}
cli::loader::main::help () 
{ 
    while (( $# > 0 )); do
        case "$1" in 
            '--')
                break
            ;;
            '-h')

            ;&
            '--help')
                cli::loader::main::invoke ${CLI_FUNCTION_HELP};
                cli::loader::help::global;
                return
            ;;
            '---help')
                cli::loader::main::invoke ${CLI_FUNCTION_HELP};
                cli::loader::help::extended;
                return
            ;;
        esac;
        shift;
    done;
    return 1
}
cli::loader::main::imports () 
{ 
    declare -F | egrep 'cli::' | awk '{ print $3 }' | while read; do
        declare -f "${REPLY}";
    done | egrep -o 'cli::intrinsic(::[0-9a-z_]+)+' | cat - <(echo 'cli::intrinsic::shim::shebang') | sort -u | sed 's/::intrinsic//g' | sed 's/::/ /g' | sed 's/_/-/g'
}
cli::loader::main::inline () 
{ 
    [[ -n "${CLI_FUNCTION_INLINE}" ]] || cli::assert;
    if [[ "${1-}" == ---* ]]; then
        while true; do
            case "$1" in 
                '---reply')
                    shift;
                    cli::loader::main::inline -- "$@";
                    echo "${REPLY-}"
                ;;
                '---mapfile')
                    shift;
                    cli::loader::main::inline -- "$@";
                    for REPLY in "${MAPFILE[@]}";
                    do
                        echo "${REPLY-}";
                    done
                ;;
                '---pipe')
                    shift;
                    while read -a MAPFILE; do
                        cli::loader::main::inline -- "$@" "${MAPFILE[@]}";
                    done
                ;;
                '---')
                    break
                ;;
                *)
                    cli::assert "Unexpected unknown internal option \"$1\" for command '${CLI_COMMAND[*]}'."
                ;;
            esac;
            return;
        done;
    fi;
    if (( $# > 0 )); then
        if [[ "${1-}" == '--' || "${1-}" == '---' ]]; then
            shift;
        fi;
        if cli::intrinsic::bash::function::is_declared ${CLI_FUNCTION_MAIN}; then
            cli::loader::main::invoke ${CLI_FUNCTION_MAIN} "$@";
            return;
        fi;
        cli::loader::main::invoke ${CLI_FUNCTION_INLINE} "$@";
        return;
    fi;
    cli::loader::emit::inline "${CLI_FUNCTION_INLINE}" "CLI_IMPORT"
}
cli::loader::main::invoke () 
{ 
    local CLI_FUNCTION="$1";
    shift;
    cli::intrinsic::bash::function::is_declared ${CLI_FUNCTION} || cli::assert "Command '${CLI_COMMAND[@]}' missing entrypoint '${CLI_FUNCTION}'.";
    cli::loader::main::cover;
    ${CLI_FUNCTION} "$@"
}
cli::loader::main::shim () 
{ 
    local LOADER_DIR=$(dirname "${BASH_SOURCE%/}");
    local LOADER_CACHE="${LOADER_DIR}/.cli/loader";
    mkdir -p "${LOADER_CACHE}";
    source "${LOADER_DIR}/../cli";
    source "$(cli ---tool-path)";
    local ROOT_DIR=$(cli ---root);
    mapfile -t LOADER_IMPORTS < <(cli::loader::main::imports);
    local LOADER_TMP=$(mktemp);
    printf '%s\n' "${LOADER_IMPORTS[@]}" | sort > "${LOADER_TMP}";
    mv -f "${LOADER_TMP}" "${LOADER_CACHE}/loader.imports.log";
    ( local -a DEPENDENCY=("${LOADER_IMPORTS[@]}");
    local -a INTRINSIC_FUNCTIONS=();
    local -i INDEX=0;
    while (( INDEX<${#DEPENDENCY[@]} )); do
        local COMMAND="${DEPENDENCY[${INDEX}]}";
        INDEX=$((INDEX + 1));
        if [[ "${COMMAND}" =~ 'cli core' ]]; then
            echo "ASSERT FAILED: Command '${COMMAND}' found." > /dev/stderr;
            continue;
        fi;
        local SEGMENTS=(${COMMAND});
        IFS='/';
        local SOURCE="${ROOT_DIR}/${SEGMENTS[*]:1}.sh";
        IFS="${CLI_IFS}";
        IFS='/';
        local FUNCTION_NAME="${SEGMENTS[*]}";
        FUNCTION_NAME="${FUNCTION_NAME//\//::}";
        FUNCTION_NAME="${FUNCTION_NAME//-/_}";
        INTRINSIC_FUNCTIONS+=("${FUNCTION_NAME}");
        IFS="${CLI_IFS}";
        local -a CLI_IMPORT=();
        source "${SOURCE}";
        declare -f "${FUNCTION_NAME}";
        local IMPORT;
        for IMPORT in "${CLI_IMPORT[@]}";
        do
            if grep -qv "${IMPORT}"; then
                DEPENDENCY+=("${IMPORT}");
            fi < <(declare -p DEPENDENCY);
        done;
    done > "${LOADER_TMP}";
    local NAME;
    for NAME in "${INTRINSIC_FUNCTIONS[@]}";
    do
        sed -i "s/${NAME}/_${NAME}/g" "${LOADER_TMP}";
    done;
    sed -i "s/_cli::/cli::intrinsic::/g" "${LOADER_TMP}" );
    cp -f "${LOADER_TMP}" "${LOADER_CACHE}/loader.intrinsic.sh";
    source "${LOADER_CACHE}/loader.intrinsic.sh";
    trap 'cli::intrinsic::stderr::on_err $?' ERR;
    CLI_LOADER_CACHE_SOURCED_PATHS[$(cli loader ---which)]=true;
    CLI_LOADER_CACHE_IMPORTED["cli .group"]=true;
    cli loader ---source;
    cli loader "$@"
}
cli::loader::self_test () 
{ 
    ( cli loader ---exports )
}
cli::loader::shim () 
{ 
    if [[ "${1-}" == ---* ]]; then
        while true; do
            case "$1" in 
                '---assert')
                    cli::assert $@
                ;;
                '---assert-subshell')
                    ( cli::assert $@ )
                ;;
                '---err')
                    function err () 
                    { 
                        return 1
                    };
                    err $@
                ;;
                '---err-subshell')
                    function err () 
                    { 
                        return 1
                    };
                    ( err $@ )
                ;;
                *)
                    break
                ;;
            esac;
            return;
        done;
    fi;
    [[ -n "${CLI_TOOL}" ]] || cli::assert "Shim failed to define CLI_TOOL.";
    [[ "${CLI_TOOL}" =~ ${CLI_REGEX_NAME} ]] || cli::assert "Bad shim name.";
    if [[ ! -v CLI_DEPTH ]]; then
        local -i CLI_DEPTH=0;
    else
        local -i CLI_DEPTH=$(( CLI_DEPTH + 1 ));
    fi;
    cli::intrinsic::name::parse "$@";
    local -a "CLI_COMMAND_${CLI_DEPTH}";
    local -n CLI_COMMAND="CLI_COMMAND_${CLI_DEPTH}";
    CLI_COMMAND=("${CLI_TOOL}" "${MAPFILE[@]}");
    readonly "CLI_COMMAND_${CLI_DEPTH}";
    shift ${#MAPFILE[@]};
    cli::intrinsic::name::to_symbol "${CLI_COMMAND[@]}";
    local -r "CLI_SYMBOL_${CLI_DEPTH}"="CLI_LOADER_${REPLY}";
    local -n CLI_SYMBOL="CLI_SYMBOL_${CLI_DEPTH}";
    local -n CLI_GROUP="${CLI_SYMBOL}_GROUP";
    local -n CLI_NAME="${CLI_SYMBOL}_NAME";
    local -n CLI_SOURCE="${CLI_SYMBOL}_SOURCE";
    local -n CLI_TYPE="${CLI_SYMBOL}_TYPE";
    local -n CLI_CACHE="${CLI_SYMBOL}_CACHE";
    local -n CLI_FUNCTION_MAIN="${CLI_SYMBOL}_FUNCTION_MAIN";
    local -n CLI_FUNCTION_INLINE="${CLI_SYMBOL}_FUNCTION_INLINE";
    local -n CLI_FUNCTION_SELF_TEST="${CLI_SYMBOL}_FUNCTION_SELF_TEST";
    local -n CLI_FUNCTION_HELP="${CLI_SYMBOL}_FUNCTION_HELP";
    if [[ ! -v CLI_GROUP ]]; then
        cli::loader::declare;
        [[ "${CLI_TYPE}" == group || -f "${CLI_SOURCE}" ]] || cli::assert "Source file '${CLI_SOURCE}' for command '${CLI_COMMAND[*]}' does not exist.";
        [[ ! -f "${CLI_SOURCE}" || -x "${CLI_SOURCE}" ]] || cli::assert "Source file '${CLI_SOURCE}' for command '${CLI_COMMAND[*]}' is not executable.";
        readonly "${CLI_SYMBOL}_GROUP" "${CLI_SYMBOL}_NAME" "${CLI_SYMBOL}_SOURCE" "${CLI_SYMBOL}_TYPE" "${CLI_SYMBOL}_CACHE" "${CLI_SYMBOL}_FUNCTION_MAIN" "${CLI_SYMBOL}_FUNCTION_INLINE" "${CLI_SYMBOL}_FUNCTION_SELF_TEST" "${CLI_SYMBOL}_FUNCTION_HELP";
    fi;
    local -r "CLI_META_${CLI_DEPTH}"="${CLI_SYMBOL}_META";
    local -n CLI_META="CLI_META_${CLI_DEPTH}";
    if [[ "${1-}" == ---* ]]; then
        while true; do
            case "$1" in 
                '---variables')
                    echo "CLI_TOOL=${CLI_TOOL}";
                    echo "CLI_COMMAND=(" "${CLI_COMMAND[@]}" ")";
                    echo "CLI_SYMBOL=${CLI_SYMBOL}";
                    echo "CLI_GROUP=${CLI_GROUP}";
                    echo "CLI_NAME=${CLI_NAME}";
                    echo "CLI_META=${CLI_META}";
                    echo "CLI_TYPE=${CLI_TYPE}";
                    echo "CLI_SOURCE=${CLI_SOURCE}";
                    echo "CLI_CACHE=${CLI_CACHE}";
                    echo "CLI_FUNCTION_MAIN=${CLI_FUNCTION_MAIN}";
                    echo "CLI_FUNCTION_INLINE=${CLI_FUNCTION_INLINE}";
                    echo "CLI_FUNCTION_SELF_TEST=${CLI_FUNCTION_SELF_TEST}";
                    echo "CLI_FUNCTION_HELP=${CLI_FUNCTION_HELP}"
                ;;
                '---command')
                    echo ${CLI_COMMAND[@]}
                ;;
                '---name')
                    echo ${CLI_NAME}
                ;;
                '---group')
                    echo ${CLI_GROUP}
                ;;
                '---type')
                    echo ${CLI_TYPE}
                ;;
                '---which')
                    echo "${CLI_SOURCE}"
                ;;
                '---cache')
                    echo "${CLI_CACHE}"
                ;;
                '---print')
                    cat "${CLI_SOURCE}"
                ;;
                '---source')
                    cli::loader::import
                ;;
                '---backpatch')
                    cli::loader::backpatch
                ;;
                '---exports')
                    if ! cli::loader::cache::test 'exports.sh'; then
                        break;
                    fi;
                    echo "${REPLY}"
                ;;
                *)
                    break
                ;;
            esac;
            return;
        done;
    fi;
    BASH_ARGV0="${CLI_SOURCE}";
    IFS="${CLI_IFS}";
    cli::loader::import_parent;
    local -n CLI_IMPORT="${CLI_SYMBOL}_IMPORT";
    if [[ ! -v CLI_IMPORT ]]; then
        declare -ag "${CLI_SYMBOL}_IMPORT+=()";
    fi;
    cli::loader::source "${CLI_SOURCE}";
    [[ ${CLI_TYPE} == inline ]] || [[ "${CLI_FUNCTION_INLINE}" == 'cli' ]] || ! cli::intrinsic::bash::function::is_declared ${CLI_FUNCTION_INLINE} || cli::assert "Command '${CLI_COMMAND[*]}' source '${CLI_SOURCE}'" "declares '${CLI_FUNCTION_INLINE}' but is missing .sh".;
    if [[ "${1-}" == ---* ]]; then
        while true; do
            case "$1" in 
                '---env')
                    declare -p
                ;;
                '---imports')
                    for i in "${CLI_IMPORT[@]}";
                    do
                        echo "${i}";
                    done
                ;;
                '---exports')
                    ! cli::loader::cache::test 'exports.sh' || cli::assert;
                    cli::loader::main::dispatch | cli::intrinsic::cache::put "${REPLY}";
                    echo "${REPLY}"
                ;;
                '---dependencies')
                    cli imports -c "${CLI_COMMAND[@]}"
                ;;
                *)
                    break
                ;;
            esac;
            return;
        done;
    fi;
    cli::loader::main::dispatch "$@"
}
cli::loader::source () 
{ 
    local SOURCE="$1";
    shift;
    if ! cli::intrinsic::set::deflower CLI_LOADER_CACHE_SOURCED_PATHS "${SOURCE}"; then
        return;
    fi;
    [[ -f "${SOURCE}" ]] || cli::assert "File missing. Cannot source path '${SOURCE}'.";
    source "${SOURCE}"
}
cli::loader::variable::list () 
{ 
    local -u GLOB;
    for i in "$@";
    do
        GLOB+="${i^^}_";
    done;
    cli::dump "${GLOB}*"
}
cli::source () 
{ 
    (( $# > 0 )) || cli::assert 'Missing import.';
    CLI_IMPORT+=("$*")
}

trap -- '' SIGPIPE
trap -- '' SIGXFSZ
trap -- 'cli::intrinsic::stderr::on_err $?' ERR

