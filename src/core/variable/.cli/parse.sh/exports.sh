cli::core::variable::parse () 
{ 
    local ARGS=("$@");
    MAPFILE=();
    (( $# >= 2 )) || cli::assert "Failed to parse type name followed by global name in '${ARGS[@]}'.";
    while [[ "${1-}" =~ ${CLI_CORE_REGEX_TYPE_NAME} ]]; do
        MAPFILE+=("$1");
        shift;
    done;
    [[ "${1-}" =~ ${CLI_CORE_REGEX_GLOBAL_NAME} ]] || cli::assert "Failed to parse type name followed by global name in '${ARGS[@]}'.";
    REPLY="$1"
}
