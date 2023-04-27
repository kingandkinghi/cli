cli::source cli subshell on-exit
cli::source cli temp remove
cli::temp::file () 
{ 
    local TEMP_FILE=$(mktemp "${1-"${TMPDIR:-/tmp/}"}cli-XXXXXXXX");
    declare -gA "CLI_SUBSHELL_TEMP_FILE_${BASHPID}+=()";
    local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
    if (( ${#CLI_SUBSHELL_TEMP_FILE_BASHPID[@]} == 0 )); then
        function cli::temp::file::on_exit () 
        { 
            local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
            cli::temp::remove "${!CLI_SUBSHELL_TEMP_FILE_BASHPID[@]}"
        };
        cli::subshell::on_exit cli::temp::file::on_exit;
    fi;
    CLI_SUBSHELL_TEMP_FILE_BASHPID+=(["${TEMP_FILE}"]='true');
    REPLY="${TEMP_FILE}"
}
