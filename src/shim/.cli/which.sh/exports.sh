cli::source cli shim which
cli::shim::which () 
{ 
    local SHIM="${1-}";
    shift;
    cli::shim::source "${SHIM}" || return 1;
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
