cli::source cli core variable declare
cli::source cli core variable get-info
cli::source cli core variable name resolve
cli::source cli core variable parse
cli::source cli set test
cli::core::variable::put () 
{ 
    local NAME=${1-};
    shift;
    cli::core::variable::get_info "${NAME}" || cli::assert "Variable '${NAME}' not defiend.";
    local TYPE="${REPLY}";
    [[ -n "${TYPE}" ]] || ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED} || cli::assert;
    local -n REF="${NAME}";
    if ${REPLY_CLI_CORE_VARIABLE_IS_BUILTIN}; then
        if ${REPLY_CLI_CORE_TYPE_IS_SCALER}; then
            (( $# <= 1 )) || cli::assert "Failed to assign '${1}' to ${TYPE} '${NAME}'." "Expected a record with one or no fields, but got '$#': $@";
            local VALUE;
            if ${REPLY_CLI_CORE_TYPE_IS_BOOLEAN}; then
                VALUE="${1-true}";
                [[ "${VALUE}" =~ ^true$|^false$ ]] || cli::assert "Failed to assign '${VALUE}' to ${TYPE} '${NAME}'.";
            else
                if ${REPLY_CLI_CORE_TYPE_IS_INTEGER}; then
                    VALUE="${1-0}";
                    [[ "${VALUE}" =~ ^[-]?[0-9]+$ ]] || cli::assert "Failed to assign '${VALUE}' to ${TYPE} '${NAME}'.";
                else
                    ${REPLY_CLI_CORE_TYPE_IS_STRING} || cli::assert;
                    VALUE="${1-}";
                fi;
            fi;
            REF="${VALUE}";
        else
            if ${REPLY_CLI_CORE_TYPE_IS_MAP}; then
                (( $# <= 2 )) || cli::assert "Failed to assign key '${1-}' value '${2-}' in map '${NAME}'." "Expected a record with two or fewer fields, but got $#: $@";
                if (( $# == 0 )); then
                    return;
                fi;
                local KEY="$1";
                local VALUE="${2-}";
                [[ "${KEY}" =~ . ]] || cli::assert "Failed to use empty key to assign '${VALUE}' to map '${NAME}'.";
                REF+=(["${KEY}"]="${VALUE}");
            else
                ${REPLY_CLI_CORE_TYPE_IS_ARRAY} || cli::assert;
                (( $# <= 2 )) || cli::assert "Failed to assign index '${1-}' value '${2-}' in array '${NAME}'." "Expected a record with two or fewer fields, but got $#: $@";
                if (( $# == 0 )); then
                    return;
                fi;
                if (( $# == 1 )); then
                    local ELEMENT="${1-}";
                    REF+=("${ELEMENT}");
                    return;
                fi;
                local INDEX="$1";
                local ELEMENT="${2-}";
                [[ "${INDEX}" =~ ^[0-9]+$ ]] || cli::assert "Failed to use index '${INDEX}' to assign '${ELEMENT}' to map '${NAME}'.";
                REF["${INDEX}"]="${ELEMENT}";
            fi;
        fi;
        return;
    fi;
    ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED} || ${REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED} || cli::assert;
    if (( $# == 0 )); then
        return;
    fi;
    local KEY="$1";
    shift;
    if ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED}; then
        TYPE="${MAPFILE[*]}";
        if ! cli::set::test REF "${KEY}"; then
            REF+=(["${KEY}"]=${#REF[@]});
        fi;
    fi;
    ARG_TYPE="${TYPE}" cli::core::variable::name::resolve "${NAME}" "${KEY}";
    local NEXT_NAME="${REPLY}";
    local NEXT_TYPE="${MAPFILE[*]}";
    cli::core::variable::declare "${NEXT_TYPE}" "${NEXT_NAME}";
    cli::core::variable::put "${NEXT_NAME}" "$@"
}
