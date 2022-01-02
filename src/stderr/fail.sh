#!/usr/bin/env CLI_NAME=cli bash-cli-part
CLI_IMPORT=(
    "cli stderr dump"
)

cli::stderr::fail::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Copies an IFS join of the arguments to stderr stream before exiting 
    with code 1.

Examples
    Test a condition
        [[ \${foo} == 'bar' ]] || ${CLI_COMMAND[@]} -- 'Foo does not equal bar.'
EOF
}

cli::stderr::fail() {
    echo "$*" \
        | cli::stderr::dump
}

cli::stderr::fail::self_test() {
    if (( $# > 0 )); then
        eval "$1"
    else
        test() {
            set -m
            if ${CLI_COMMAND[@]} --self-test -- "$@" 2>&1; then exit 1; fi 
        }

        diff <( test "cli::stderr::fail 'Bad news'" ) \
            <( echo 'Bad news' ) || cli::assert
    fi
}
