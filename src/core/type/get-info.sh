#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli core type unmodify"
)

cli::core::type::get_info::help() {
    cat << EOF | cli::core::type::help
Command
    ${CLI_COMMAND[@]}
    
Summary
    Get type information.

Description
    Arguments \$1 - \$n represent a type.

    Set REPLY to the name of a user defined type or empty or
    empty if the type is modified or builtin.

    Set predicates:

        REPLY_CLI_CORE_TYPE_IS_INTEGER
        REPLY_CLI_CORE_TYPE_IS_BOOLEAN
        REPLY_CLI_CORE_TYPE_IS_STRING
        REPLY_CLI_CORE_TYPE_IS_SCALER
        REPLY_CLI_CORE_TYPE_IS_BUILTIN
        REPLY_CLI_CORE_TYPE_IS_ARRAY
        REPLY_CLI_CORE_TYPE_IS_MAP
        REPLY_CLI_CORE_TYPE_IS_MODIFIED
        REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    If type type is modified, then all the above predicates are false,
    predicate REPLY_CLI_CORE_TYPE_IS_MODIFIED is true, and array
    MAPFILE contains the unmodified type.

    If type is umodified then MAPFILE contains a copy of the type.
EOF
}

cli::core::type::get_info() {
    MAPFILE=( "$@" )
    REPLY="${MAPFILE[@]}"

    # cache
    if [[ "${REPLY_CLI_CORE_TYPE-}" == "${REPLY}" ]]; then
        return
    fi
    REPLY_CLI_CORE_TYPE="$@"

    REPLY_CLI_CORE_TYPE_IS_INTEGER=false
    REPLY_CLI_CORE_TYPE_IS_BOOLEAN=false
    REPLY_CLI_CORE_TYPE_IS_STRING=false
    REPLY_CLI_CORE_TYPE_IS_SCALER=false
    REPLY_CLI_CORE_TYPE_IS_BUILTIN=false
    REPLY_CLI_CORE_TYPE_IS_ARRAY=false
    REPLY_CLI_CORE_TYPE_IS_MAP=false
    REPLY_CLI_CORE_TYPE_IS_MODIFIED=false
    REPLY_CLI_CORE_TYPE_IS_USER_DEFINED=false

    # modified
    while [[ "${MAPFILE}" == 'map_of' ]]; do
        REPLY_CLI_CORE_TYPE_IS_MODIFIED=true
        cli::core::type::unmodify "$@"
        REPLY="${REPLY_CLI_CORE_TYPE}"
        return
    done

    # scaler
    while true; do
        case "${MAPFILE}" in
            'string') REPLY_CLI_CORE_TYPE_IS_STRING=true ;;
            'integer') REPLY_CLI_CORE_TYPE_IS_INTEGER=true ;;
            'boolean') REPLY_CLI_CORE_TYPE_IS_BOOLEAN=true ;;
            *) break    
        esac

        REPLY_CLI_CORE_TYPE_IS_BUILTIN=true
        REPLY_CLI_CORE_TYPE_IS_SCALER=true       
        return
    done

    # indexable
    while true; do
        case "${MAPFILE}" in
            'array') REPLY_CLI_CORE_TYPE_IS_ARRAY=true ;;        
            'map') REPLY_CLI_CORE_TYPE_IS_MAP=true ;;        
            *) break    
        esac

        REPLY_CLI_CORE_TYPE_IS_BUILTIN=true
        return
    done

    # user defined
    [[ "${MAPFILE}" =~ ${CLI_CORE_REGEX_TYPE_NAME} ]] \
        || cli::assert "Expected type name to match '${CLI_CORE_REGEX_TYPE_NAME}', but got '${MAPFILE}'."

    REPLY_CLI_CORE_TYPE_IS_USER_DEFINED=true
}

cli::core::type::get_info::self_test() {

    cli::core::type::get_info udt
    [[ "${REPLY}" == 'udt' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'udt' ]]
    [[ "${MAPFILE[*]}" == 'udt' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    ! $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    ! $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info string
    [[ "${REPLY}" == 'string' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'string' ]]
    [[ "${MAPFILE[*]}" == 'string' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    $REPLY_CLI_CORE_TYPE_IS_STRING
    $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info boolean
    [[ "${REPLY}" == 'boolean' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'boolean' ]]
    [[ "${MAPFILE[*]}" == 'boolean' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info integer
    [[ "${REPLY}" == 'integer' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'integer' ]]
    [[ "${MAPFILE[*]}" == 'integer' ]]
    $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info map
    [[ "${REPLY}" == 'map' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'map' ]]
    [[ "${MAPFILE[*]}" == 'map' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    ! $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    $REPLY_CLI_CORE_TYPE_IS_MAP
    $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info array
    [[ "${REPLY}" == 'array' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'array' ]]
    [[ "${MAPFILE[*]}" == 'array' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    ! $REPLY_CLI_CORE_TYPE_IS_SCALER
    $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info map_of udt
    [[ "${REPLY}" == 'map_of udt' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'map_of udt' ]]
    [[ "${MAPFILE[*]}" == 'udt' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    ! $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    ! $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED

    cli::core::type::get_info map_of map_of udt
    [[ "${REPLY}" == 'map_of map_of udt' ]]
    [[ "${REPLY_CLI_CORE_TYPE}" == 'map_of map_of udt' ]]
    [[ "${MAPFILE[*]}" == 'map_of udt' ]]
    ! $REPLY_CLI_CORE_TYPE_IS_INTEGER
    ! $REPLY_CLI_CORE_TYPE_IS_BOOLEAN
    ! $REPLY_CLI_CORE_TYPE_IS_STRING
    ! $REPLY_CLI_CORE_TYPE_IS_SCALER
    ! $REPLY_CLI_CORE_TYPE_IS_ARRAY
    ! $REPLY_CLI_CORE_TYPE_IS_MAP
    ! $REPLY_CLI_CORE_TYPE_IS_BUILTIN
    $REPLY_CLI_CORE_TYPE_IS_MODIFIED
    ! $REPLY_CLI_CORE_TYPE_IS_USER_DEFINED
}
