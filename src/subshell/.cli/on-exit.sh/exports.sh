cli::subshell::on_exit () 
{ 
    local -ga "CLI_SUBSHELL_ON_EXIT_${BASHPID}+=()";
    local -n CLI_SUBSHELL_ON_EXIT=CLI_SUBSHELL_ON_EXIT_${BASHPID};
    if (( ${#CLI_SUBSHELL_ON_EXIT[@]} == 0 )); then
        function cli::subshell::on_exit::trap () 
        { 
            local -n CLI_SUBSHELL_ON_EXIT=CLI_SUBSHELL_ON_EXIT_${BASHPID};
            local DELEGATE;
            for DELEGATE in ${CLI_SUBSHELL_ON_EXIT[@]};
            do
                ${DELEGATE};
            done
        };
        trap cli::subshell::on_exit::trap EXIT;
    fi;
    CLI_SUBSHELL_ON_EXIT+=("$@")
}
