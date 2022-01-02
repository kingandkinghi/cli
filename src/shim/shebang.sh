#!/usr/bin/env CLI_NAME=cli bash-cli-part
CLI_IMPORT=(
    "cli path make-absolute"
    "cli path name"
    "cli shim source"
)

cli::shim::shebang::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Shim to execute a command invoked as a file.

Details
    The variable CLI_NAME must be declared and set to the name of the shim.

    Argument \$1 is the path to the command file. The remaining positional 
    arguments are to be passed to the command.

    Construct the equivalent invocation using the shim and invoke that.
EOF
}

cli::shim::shebang() {    

    # CLI_NAME
    [[ "${CLI_NAME}" ]] \
        || cli::assert "Shebang failed to declare 'CLI_NAME'." 

    # SHIM_ROOT_DIR_REF
    cli::shim::source "${CLI_NAME}" \
        || cli::assert "Shebang failed to find shim for cli '${CLI_NAME}'."
    local -n SHIM_ROOT_DIR_REF="CLI_SHIM_ROOT_DIR_${CLI_NAME^^}"

    # SOURCE_PATH
    cli::path::make_absolute "$1"
    local SOURCE_PATH="${REPLY}"
    shift

    # REL_PATH
    local REL_PATH="${SOURCE_PATH##"${SHIM_ROOT_DIR_REF}/"}"
    (( ${#REL_PATH} < ${#SOURCE_PATH} )) \
        || cli::assert "Source path '${SOURCE_PATH}' is not a subpath of '${SHIM_ROOT_DIR_REF}'." 

    # COMMAND
    local IFS=/
    local -a COMMAND=( ${CLI_NAME} ${REL_PATH} )
    IFS=${CLI_IFS}

    set "${COMMAND[@]}" "$@"

    # epilog
    unset REL_PATH
    unset SOURCE_PATH
    unset COMMAND
    unset -n SHIM_ROOT_DIR_REF

    # post conditions
    [[ -v CLI_NAME ]] || cli::assert

    "$@" 
}

cli::shim::shebang::self_test() (

    cli::temp::dir 
    local DIR="${REPLY}"
    local FOO_SHIM="${DIR}/foo"
    local FOO_SRC_DIR="${DIR}/src"
    local FOO_BAR="${DIR}/src/bar"

    # emit foo shim
    cat <<-EOF > "${FOO_SHIM}"
		declare -rg CLI_SHIM_ROOT_DIR_FOO="\${FOO_SRC_DIR}"
		foo() { echo "\$@"; }
		EOF
    chmod a+x "${FOO_SHIM}"

    # update PATH
    PATH="${DIR}:${PATH}"

    # discover, source, and invoke the shim with the command
    diff <(CLI_NAME=foo cli::shim::shebang "${FOO_BAR}" -- a0 a1 a2) - <<< 'bar -- a0 a1 a2' \
        || cli::assert
)
