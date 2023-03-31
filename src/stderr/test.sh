CLI_IMPORT=(
    "cli stderr fail"
)

cli::stderr::test::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Test that a command fails and generates an error message.

Description
    First argument is the command to be evaluated.
    Second argument is the error message to test.
EOF
}

cli::stderr::test() {
    # cli::stderr::fail sends a signal to its own process group. Terminating its own process 
    # group has the effect of unwinding the stack to the process owning the process group. 
    # If cli::stderr::fail only called 'exit' instead of sending a signal then the stack would
    # only unwind to the top of the calling subshell which may then throw an error that its 
    # child died which would unwind to the top of its subprocess and repeat resulting in a
    # cascade of failures and noisy error messages. 

    # Enabling job control (set -m) causes all new processes to be created in a new
    # process group. We then create a new process in a new process group and assert that
    # it returns a failure code. Inside the new process we re-enable job control (set +m)
    # which has the effect of creating all subsequent processes in the same process
    # group. This way when cli::stderr::fail is called all process in the new process
    # group are rolled up.
    
    # cli::stderr::fail writes its error messages to stderr. We redirect stderr to stdout
    # so that diff can see the output and we can assert the correct error message.
    diff <( set -m; ! ( set +m; ( eval "$1" 2>&1 ); cli::assert ) || cli::assert ) - <<< "$2"
}

cli::stderr::test::self_test() {
    cli::stderr::test 'cli::stderr::fail "failed!"' 'failed!'
    ! cli::stderr::test 'cli::stderr::fail "failed!"' 'success!' >/dev/null
}
