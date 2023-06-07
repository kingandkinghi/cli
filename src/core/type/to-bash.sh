#!/usr/bin/env CLI_TOOL=cli bash-cli-part

cli::core::type::to_bash::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Return bash type given a core type.

Description
    Argument \$1 - \$n represent a type.

    REPLY contains the name of bash type.
EOF
}

cli::core::type::to_bash() {
    local TYPE="${1-}"

    case "${TYPE}" in
        'string') REPLY= ;;
        'integer') REPLY=i ;;
        'array') REPLY=a ;;
        'map') REPLY=A ;;
        'map_of') REPLY=A ;;
        'boolean') REPLY= ;;
        *) return 1 ;;
    esac
}

cli::core::type::to_bash::self_test() {
    cli::core::type::to_bash string
    [[ "${REPLY}" == '' ]]

    cli::core::type::to_bash integer
    [[ "${REPLY}" == 'i' ]]

    cli::core::type::to_bash boolean
    [[ "${REPLY}" == '' ]]

    cli::core::type::to_bash array
    [[ "${REPLY}" == 'a' ]]

    cli::core::type::to_bash map
    [[ "${REPLY}" == 'A' ]]

    cli::core::type::to_bash map_of array
    [[ "${REPLY}" == 'A' ]]

    ! cli::core::type::to_bash udt
}
