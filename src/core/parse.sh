#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli args parse"
    "cli args resolve"
    "cli args tokenize"
    "cli args verify"
    "cli core variable resolve"
    "cli core variable get-info"
    "cli core variable declare"
    "cli core variable read"
)

cli::core::parse::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]} 

Summary    
    Parses command line arguments.

Declare
    ARG_SCOPE is the name of the scope.
    CLI_META is the name of the metadata for the arguments.

    \$1 - \$n are command line arguments.

    REPLY_CLI_ARGS_TOKENS is the argument tokens.
    REPLY_CLI_ARGS_PARSE is the parsed arguments.
    REPLY is the metadata for the argument group.
EOF
}

cli::core::parse::main() {
    local -A SCOPE=()
    ARG_SCOPE='SCOPE'

    ARG_TYPE='cli_meta' cli::core::variable::declare MY_META
    cli::core::variable::read MY_META

    cli::core::parse MY_META "$@"
}

cli::core::parse() {
    [[ "${ARG_SCOPE-}" ]] || cli::assert 'Missing scope.'

    local META="$1"
    shift

    cli::args::tokenize "$@"
    cli::args::parse "${META}_ALIAS" "${REPLY}"
    local ARGS="${REPLY}"

    cli::args::resolve "${META}_GROUP" "${ARGS}"
    cli::core::variable::resolve "${META}_GROUP" "${REPLY}"
    local META_GROUP="${REPLY}"

    cli::args::verify "${META_GROUP}" "${ARGS}"
    REPLY="${META_GROUP}"
}

cli::core::parse::self_test() {
    cli core parse -- --id 42 -f banana -h --header Foo -- a0 a1 \
        < <( cli sample kitchen-sink ---load )
}   
