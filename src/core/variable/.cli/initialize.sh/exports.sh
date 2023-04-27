cli::source cli core variable get-info
cli::source cli core variable name fields
cli::core::variable::initialize () 
{ 
    local SCOPE_NAME="${ARG_SCOPE-}";
    [[ -n "${SCOPE_NAME}" ]] || cli::assert 'Missing scope.';
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing name.';
    cli::core::variable::get_info ${NAME};
    local TYPE="${REPLY}";
    local -n REF="${NAME}";
    if ${REPLY_CLI_CORE_VARIABLE_IS_STRING}; then
        REF=;
    else
        if ${REPLY_CLI_CORE_VARIABLE_IS_INTEGER}; then
            REF=0;
        else
            if ${REPLY_CLI_CORE_VARIABLE_IS_BOOLEAN}; then
                REF=false;
            else
                if ${REPLY_CLI_CORE_VARIABLE_IS_ARRAY}; then
                    REF=();
                else
                    if ${REPLY_CLI_CORE_VARIABLE_IS_MAP}; then
                        REF=();
                    else
                        if ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED}; then
                            REF=();
                        else
                            ${REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED} || cli::assert;
                            ARG_TYPE=${TYPE} cli::core::variable::name::fields ${NAME};
                            local FIELD_NAMES=("${MAPFILE[@]}");
                            local FIELD_NAME;
                            for FIELD_NAME in "${FIELD_NAMES[@]}";
                            do
                                cli::core::variable::initialize "${FIELD_NAME}";
                            done;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi
}
