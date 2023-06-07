#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli core type get"
    "cli core type get-info"
    "cli core variable get-info"
    "cli core variable name resolve"
)

cli::core::variable::layout::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Given a variable name and type write a record for each field consisting of
    the bash variable name followed by the bash type.

Description
    Argument \$1 is the the name of the variable (e.g. MY_MAP_OF_ARRAY).
    Argument \$2 is the type of the variable  (e.g. 'map_of array').
EOF
}

cli::core::variable::layout() {
    local TYPE="${1-}"
    [[ "${TYPE}" ]] || cli::assert 'Missing type.'
    shift

    local NAME="${1-}"
    [[ "${NAME}" ]] || cli::assert 'Missing name.'
    shift

    # assoicate variable with its type
    echo "${NAME}" "${TYPE}"

    cli::core::type::get_info ${TYPE} # split

    # user defined
    if ${REPLY_CLI_CORE_TYPE_IS_USER_DEFINED}; then
        local USER_DEFINED_TYPE=${REPLY}

        cli::core::type::get ${USER_DEFINED_TYPE}
        local -n TYPE_REF=${REPLY}

        # layout fields
        local FIELD_NAME
        for FIELD_NAME in "${!TYPE_REF[@]}"; do

            # resolve bash variable for field
            ARG_TYPE="${USER_DEFINED_TYPE}" \
                cli::core::variable::name::resolve "${NAME}" "${FIELD_NAME}"
            local FIELD_TYPE="${MAPFILE[*]}"

            # recursively initialize bash variable for field
            cli::core::variable::layout "${FIELD_TYPE}" "${REPLY}"
        done
    fi
}

cli::core::variable::layout::self_test() {
    diff <(cli::core::variable::layout string MY_STRING) - <<< 'MY_STRING string'
    diff <(cli::core::variable::layout boolean MY_BOOLEAN) - <<< 'MY_BOOLEAN boolean'
    diff <(cli::core::variable::layout integer MY_INTEGER) - <<< 'MY_INTEGER integer'
    diff <(cli::core::variable::layout array MY_ARRAY) - <<< 'MY_ARRAY array'
    diff <(cli::core::variable::layout map MY_MAP) - <<< 'MY_MAP map'

    local -A CLI_TYPE_VERSION=(
        [major]='integer'
        [minor]='integer'
    )
    diff <(cli::core::variable::layout version MY_VERSION | sort) - <<-EOF
		MY_VERSION version
		MY_VERSION_MAJOR integer
		MY_VERSION_MINOR integer
		EOF
        
    local -A CLI_TYPE_UDT=(
        [my_string]='string'
        [my_integer]='integer'
        [my_boolean]='boolean'
        [my_map]='map'
        [my_array]='array'
        [my_map_of_string]='map_of string'
        [my_version]='version'
        [my_map_of_version]='map_of version'
    )
    diff <(cli::core::variable::layout udt MY_UDT | sort) - <<-EOF
		MY_UDT udt
		MY_UDT_MY_ARRAY array
		MY_UDT_MY_BOOLEAN boolean
		MY_UDT_MY_INTEGER integer
		MY_UDT_MY_MAP map
		MY_UDT_MY_MAP_OF_STRING map_of string
		MY_UDT_MY_MAP_OF_VERSION map_of version
		MY_UDT_MY_STRING string
		MY_UDT_MY_VERSION version
		MY_UDT_MY_VERSION_MAJOR integer
		MY_UDT_MY_VERSION_MINOR integer
		EOF
}
