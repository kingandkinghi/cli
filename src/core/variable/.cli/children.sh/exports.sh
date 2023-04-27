cli::source cli core variable get-info
cli::source cli core variable name fields
cli::source cli core variable name modifications
cli::core::variable::children () 
{ 
    [[ -n ${ARG_SCOPE} ]] || cli::assert 'Missing scope.';
    local -n SCOPE_REF=${ARG_SCOPE};
    local NAME="$1";
    [[ -n ${NAME} ]] || cli::assert 'Missing variable name.';
    if ! cli::core::variable::get_info "${NAME}" || ${REPLY_CLI_CORE_VARIABLE_IS_BUILTIN}; then
        MAPFILE=();
        return;
    fi;
    if ${REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED}; then
        ARG_TYPE="${REPLY}" cli::core::variable::name::fields ${NAME};
    else
        if ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED}; then
            ARG_TYPE="${REPLY}" cli::core::variable::name::modifications ${NAME};
        fi;
    fi
}
