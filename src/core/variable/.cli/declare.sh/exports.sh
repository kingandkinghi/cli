cli::source cli core type get
cli::source cli core type get-info
cli::source cli core variable get-info
cli::source cli core variable name resolve
cli::core::variable::declare () 
{ 
    cli::assert
    declare -p FUNCNAME >&2
    if [[ ! "${FUNCNAME[1]}" == 'cli::core::variable::declare' ]]; then
        echo "declare -Ag REPLY_CLI_CORE_VARIABLE_DECLARE=();" >&2
        declare -Ag REPLY_CLI_CORE_VARIABLE_DECLARE=();
    fi;
    local TYPE="${1-}";
    [[ -n "${TYPE}" ]] || cli::assert 'Missing type.';
    shift;
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing name.';
    shift;
    declare -p REPLY_CLI_CORE_VARIABLE_DECLARE NAME TYPE >&2
    REPLY_CLI_CORE_VARIABLE_DECLARE["${NAME}"]="${TYPE}";
    cli::core::type::get_info ${TYPE};
    if ${REPLY_CLI_CORE_TYPE_IS_USER_DEFINED}; then
        local USER_DEFINED_TYPE=${REPLY};
        cli::core::type::get ${USER_DEFINED_TYPE};
        local -n TYPE_REF=${REPLY};
        local FIELD_NAME;
        for FIELD_NAME in "${!TYPE_REF[@]}";
        do
            ARG_TYPE="${USER_DEFINED_TYPE}" cli::core::variable::name::resolve "${NAME}" "${FIELD_NAME}";
            local FIELD_TYPE="${MAPFILE[*]}";
            cli::core::variable::declare "${FIELD_TYPE}" "${REPLY}";
        done;
    fi
}
