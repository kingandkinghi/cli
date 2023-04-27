cli::source cli bash stack trace
cli::source cli stderr dump
cli::stderr::on_err () 
{ 
    local -a CLI_PIPESTATUS=("${PIPESTATUS[@]}");
    local CLI_TRAP_EXIT_CODE=${1-'?'};
    local BPID="${BASHPID}";
    if [[ ! $- =~ e ]]; then
        return;
    fi;
    { 
        echo -n "TRAP ERR: exit=${CLI_TRAP_EXIT_CODE}";
        if (( ${#CLI_PIPESTATUS[@]} > 1 )); then
            echo -n ", pipe=[$(cli::bash::join ',' "${CLI_PIPESTATUS[@]}")]";
        fi;
        echo ", bpid=${BPID}, pid=$$";
        echo "BASH_COMMAND ERR: ${BASH_COMMAND}";
        cli::bash::stack::trace | sed 's/^/  /'
    } | cli::stderr::dump
}
