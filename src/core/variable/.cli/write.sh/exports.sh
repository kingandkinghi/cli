cli::source cli bash write
cli::source cli core type get
cli::source cli core variable get-info
cli::source cli core variable resolve
cli::core::variable::write () 
{ 
    local ARG_SCOPE=${ARG_SCOPE-'CLI_SCOPE'};
    local NAME="${1-}";
    cli::core::variable::get_info "${NAME}" || cli::assert "Variable '${NAME}' not found in scope.";
    local TYPE="${MAPFILE[*]}";
    local PREFIX_NAME=CLI_CORE_VARIABLE_WRITE_PREFIX;
    local -n PREFIX=CLI_CORE_VARIABLE_WRITE_PREFIX;
    if ${REPLY_CLI_CORE_VARIABLE_IS_BUILTIN}; then
        local -n REF=${NAME};
        if ${REPLY_CLI_CORE_VARIABLE_IS_BOOLEAN}; then
            if ${REF}; then
                cli::bash::write "${PREFIX[@]}";
            fi;
        else
            if ${REPLY_CLI_CORE_VARIABLE_IS_SCALER}; then
                cli::bash::write "${PREFIX[@]}" "${REF}";
            else
                if ${REPLY_CLI_CORE_VARIABLE_IS_ARRAY}; then
                    local INDEX;
                    for INDEX in "${!REF[@]}";
                    do
                        cli::bash::write "${PREFIX[@]}" "${INDEX}" "${REF[INDEX]}";
                    done;
                else
                    ${REPLY_CLI_CORE_VARIABLE_IS_MAP} || cli::assert;
                    local KEY;
                    for KEY in ${!REF[@]};
                    do
                        cli::bash::write "${PREFIX[@]}" "${KEY}" "${REF[$KEY]}";
                    done;
                fi;
            fi;
        fi;
    else
        local -a SEGMENTS;
        if ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED}; then
            local -n ORDINALS_REF=${NAME};
            SEGMENTS=("${!ORDINALS_REF[@]}");
        else
            ${REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED} || cli::assert;
            local USER_DEFINED_TYPE="${REPLY}";
            cli::core::type::get "${USER_DEFINED_TYPE}";
            local -n TYPE_REF="${REPLY}";
            SEGMENTS=("${!TYPE_REF[@]}");
        fi;
        local -a PREFIX_COPY=("${PREFIX[@]}");
        local SEGMENT;
        for SEGMENT in "${SEGMENTS[@]}";
        do
            local -a CLI_CORE_VARIABLE_WRITE_PREFIX=("${PREFIX_COPY[@]}" "${SEGMENT}");
            cli::core::variable::resolve "${NAME}" "${SEGMENT}";
            cli::core::variable::write "${REPLY}";
        done;
    fi
}
