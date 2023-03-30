#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli args check"
    "cli args tokenize"
    "cli args parse"
    "cli core variable declare"
    "cli core variable put"
    "cli core variable read"
    "cli core variable resolve"
    "cli core variable write"
    "cli set intersect"
)

cli::args::reslove::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Return the command group implied by switches found in the arguments.

Description
    Argument \$1 is variable of type 'cli_meta'.

    Stdin contains a stream of type 'cli_args'.

    ARG_SCOPE is the working scope.

    RESULT is a variable of type 'cli_meta_group'.

EOF
    cat << EOF

Examples
    cli args tokenize -- --header foo --help \\
        | cli args parse \\
        | cli args check -- \\
            <( cli sample kitchen-sink ---load )
EOF
}

cli::args::resolve::main() {
    local -A SCOPE=()
    ARG_SCOPE='SCOPE'

    cli::core::variable::declare cli_meta MY_META
    cli::core::variable::read MY_META
    cli::args::tokenize "$@"
    cli::args::parse MY_META_ALIAS "${REPLY}"
    cli::args::resolve MY_META_GROUP "${REPLY}"
    echo "${REPLY}"
}

cli::args::resolve() {
    [[ "${ARG_SCOPE:-}" ]] || cli::assert 'Missing scope.'

    local META_GROUP="$1"
    shift

    local ARGS="$1"
    shift

    local -n GROUP_REF="${META_GROUP}"

    if (( ${#GROUP_REF[@]} == 1 )); then
        REPLY='*'
        return
    fi

    cli::set::intersect "${META_GROUP}" "${ARGS}_NAMED"
    
    (( ${#REPLY_MAP[@]} == 1 )) \
        || cli::assert \
            "Expected a single named argument from the set { ${!GROUP_REF[@]} }" \
            "be declared to discriminate the command group." \
            "Instead '${REPLY_MAP[@]}' discrimiator(s) were declared."

    REPLY="${!REPLY_MAP[@]}"
    # cli::core::variable::resolve "${META_GROUP}" "${GROUP_ID}"
}

cli::args::resolve::self_test() {

    diff <(
        cli args resolve -- --id 42 -f banana -h --header Foo -- a0 a1 \
            < <( cli sample kitchen-sink ---load )
    ) - <<< 'id'

    diff <(
        cli args resolve -- --name foo -f banana -h --header Foo -- a0 a1 \
            < <( cli sample kitchen-sink ---load )
    ) - <<< 'name'

    diff <(
        cli args resolve -- -f banana -h --header Foo -- a0 a1 \
            < <( cli sample simple ---load )
    ) - <<< '*'
}
