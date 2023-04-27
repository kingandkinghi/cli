cli::source cli bash variable get-info
cli::source cli core type get
cli::source cli core type get-info
cli::source cli core type to-bash
cli::source cli core variable parse
cli::source cli core variable get-info
cli::source cli core variable initialize
cli::source cli core variable name resolve
cli::source cli core variable unset
cli::source cli set test
cli::core::variable::declare () 
{ 
    local SCOPE_NAME="${ARG_SCOPE-}";
    [[ -n "${SCOPE_NAME}" ]] || cli::assert 'Missing scope.';
    local TYPE="${1-}";
    [[ -n "${TYPE}" ]] || cli::assert 'Missing type.';
    shift;
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing name.';
    shift;
    if cli::core::variable::get_info "${NAME}"; then
        local EXISTING_TYPE="${MAPFILE[*]}";
        [[ "${EXISTING_TYPE}" == "${TYPE}" ]] || cli::assert "Variable '${NAME}' of type '${EXISTING_TYPE}'" "cannot be redclared type '${TYPE}'.";
        return;
    fi;
    ! cli::bash::variable::get_info "${NAME}" || cli::assert "Failed to declare '${NAME}'." "Variable '${NAME}' already declared in bash as:" "$( declare -p "${NAME}" )";
    local -n SCOPE_REF="${SCOPE_NAME}";
    SCOPE_REF["${NAME}"]="${TYPE}";
    cli::core::type::get_info ${TYPE};
    if ! ${REPLY_CLI_CORE_TYPE_IS_USER_DEFINED}; then
        cli::core::type::to_bash ${TYPE};
        declare -g${REPLY} ${NAME};
        cli::core::variable::initialize "${NAME}";
    else
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
