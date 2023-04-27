cli::source cli core type get
cli::source cli core type get-info
cli::source cli core type unmodify
cli::core::variable::name::resolve () 
{ 
    local TYPE=(${ARG_TYPE-});
    [[ -n "${TYPE[@]}" ]] || cli::assert 'Missing type.';
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing name.';
    [[ "${NAME}" =~ ${CLI_REGEX_GLOBAL_NAME} ]] || cli::assert "Bad bash name '${NAME}'.";
    shift;
    for i in "$@";
    do
        cli::core::type::get_info "${TYPE[@]}";
        if ${REPLY_CLI_CORE_TYPE_IS_BUILTIN}; then
            if ${REPLY_CLI_CORE_TYPE_IS_ARRAY}; then
                (( $# == 0 )) || cli::assert "Array cannot have field '$@'.";
            else
                if ${REPLY_CLI_CORE_TYPE_IS_MAP}; then
                    (( $# == 0 )) || cli::assert "Map cannot have field '$@'.";
                else
                    (( $# == 0 )) || cli::assert "Scaler of type '${TYPE}' cannot have field '$@'.";
                fi;
            fi;
        else
            if ${REPLY_CLI_CORE_TYPE_IS_MODIFIED}; then
                local -n ORDINAL_MAP=${NAME};
                [[ "${ORDINAL_MAP["$i"]+set}" == 'set' ]] || cli::assert "Failed to resolve key '$i' in '${NAME}'.";
                NAME=${NAME}_${ORDINAL_MAP["$i"]};
                cli::core::type::unmodify "${MAPFILE[@]}";
                TYPE=(${MAPFILE[@]});
            else
                ${REPLY_CLI_CORE_TYPE_IS_USER_DEFINED} || cli::assert "Expected user defined type but got '${TYPE[@]}'.";
                cli::core::type::get "${REPLY}";
                local -n TYPE_REF="${REPLY}";
                if [[ ! "${TYPE_REF[$i]+set}" == 'set' ]]; then
                    cli::assert "Field '$i' not found in '${TYPE}' fields: { ${!TYPE_REF[@]} }.";
                fi;
                TYPE=(${TYPE_REF["$i"]});
                NAME=${NAME}_${i^^};
            fi;
        fi;
    done;
    MAPFILE=("${TYPE[@]}");
    REPLY="${NAME}"
}
