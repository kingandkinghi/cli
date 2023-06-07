cli::source cli core type unmodify
cli::core::type::get_info () 
{ 
    MAPFILE=("$@");
    REPLY="${MAPFILE[@]}";
    if [[ "${REPLY_CLI_CORE_TYPE-}" == "${REPLY}" ]]; then
        return;
    fi;
    REPLY_CLI_CORE_TYPE="$@";
    REPLY_CLI_CORE_TYPE_IS_INTEGER=false;
    REPLY_CLI_CORE_TYPE_IS_BOOLEAN=false;
    REPLY_CLI_CORE_TYPE_IS_STRING=false;
    REPLY_CLI_CORE_TYPE_IS_SCALER=false;
    REPLY_CLI_CORE_TYPE_IS_BUILTIN=false;
    REPLY_CLI_CORE_TYPE_IS_ARRAY=false;
    REPLY_CLI_CORE_TYPE_IS_MAP=false;
    REPLY_CLI_CORE_TYPE_IS_MODIFIED=false;
    REPLY_CLI_CORE_TYPE_IS_USER_DEFINED=false;
    while [[ "${MAPFILE}" == 'map_of' ]]; do
        REPLY_CLI_CORE_TYPE_IS_MODIFIED=true;
        cli::core::type::unmodify "$@";
        REPLY="${REPLY_CLI_CORE_TYPE}";
        return;
    done;
    while true; do
        case "${MAPFILE}" in 
            'string')
                REPLY_CLI_CORE_TYPE_IS_STRING=true
            ;;
            'integer')
                REPLY_CLI_CORE_TYPE_IS_INTEGER=true
            ;;
            'boolean')
                REPLY_CLI_CORE_TYPE_IS_BOOLEAN=true
            ;;
            *)
                break
            ;;
        esac;
        REPLY_CLI_CORE_TYPE_IS_BUILTIN=true;
        REPLY_CLI_CORE_TYPE_IS_SCALER=true;
        return;
    done;
    while true; do
        case "${MAPFILE}" in 
            'array')
                REPLY_CLI_CORE_TYPE_IS_ARRAY=true
            ;;
            'map')
                REPLY_CLI_CORE_TYPE_IS_MAP=true
            ;;
            *)
                break
            ;;
        esac;
        REPLY_CLI_CORE_TYPE_IS_BUILTIN=true;
        return;
    done;
    [[ "${MAPFILE}" =~ ${CLI_CORE_REGEX_TYPE_NAME} ]] || cli::assert "Expected type name to match '${CLI_CORE_REGEX_TYPE_NAME}', but got '${MAPFILE}'.";
    REPLY_CLI_CORE_TYPE_IS_USER_DEFINED=true
}
