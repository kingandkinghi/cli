cli::source cli core type get-info
cli::core::variable::get_info () 
{ 
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing variable name.';
    [[ "${NAME}" =~ ${CLI_REGEX_GLOBAL_NAME} ]] || cli::assert "Bad variable name '${NAME}'.";
    local SCOPE_NAME="${ARG_SCOPE}";
    [[ -n "${SCOPE_NAME}" ]] || cli::assert 'Missing scope.';
    local -n SCOPE_REF="${SCOPE_NAME}";
    if [[ ! "${SCOPE_REF["${NAME}"]+set}" == 'set' ]]; then
        return 1;
    fi;
    local TYPE="${SCOPE_REF["${NAME}"]}";
    [[ -n ${TYPE} ]] || cli::assert;
    cli::core::type::get_info ${TYPE};
    REPLY_CLI_CORE_VARIABLE_IS_INTEGER=${REPLY_CLI_CORE_TYPE_IS_INTEGER};
    REPLY_CLI_CORE_VARIABLE_IS_BOOLEAN=${REPLY_CLI_CORE_TYPE_IS_BOOLEAN};
    REPLY_CLI_CORE_VARIABLE_IS_STRING=${REPLY_CLI_CORE_TYPE_IS_STRING};
    REPLY_CLI_CORE_VARIABLE_IS_SCALER=${REPLY_CLI_CORE_TYPE_IS_SCALER};
    REPLY_CLI_CORE_VARIABLE_IS_ARRAY=${REPLY_CLI_CORE_TYPE_IS_ARRAY};
    REPLY_CLI_CORE_VARIABLE_IS_MAP=${REPLY_CLI_CORE_TYPE_IS_MAP};
    REPLY_CLI_CORE_VARIABLE_IS_BUILTIN=${REPLY_CLI_CORE_TYPE_IS_BUILTIN};
    REPLY_CLI_CORE_VARIABLE_IS_MODIFIED=${REPLY_CLI_CORE_TYPE_IS_MODIFIED};
    REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED=${REPLY_CLI_CORE_TYPE_IS_USER_DEFINED}
}
