cli::source cli path make-absolute
cli::source cli path name
cli::source cli shim source
cli::shim::shebang () 
{ 
    local SOURCE_PATH_RELATIVE="${1-}";
    shift;
    cli::path::make_absolute "${SOURCE_PATH_RELATIVE}";
    local SOURCE_PATH="${REPLY}";
    [[ -n "${CLI_TOOL}" ]] || cli::assert "Shebang failed to declare 'CLI_TOOL'.";
    cli::shim::source "${CLI_TOOL}" || cli::assert "Shebang failed to find shim for cli '${CLI_TOOL}'.";
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
