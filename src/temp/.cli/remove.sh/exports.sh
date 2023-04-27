cli::temp::remove () 
{ 
    local -n CLI_SUBSHELL_TEMP_FILE_BASHPID=CLI_SUBSHELL_TEMP_FILE_${BASHPID};
    for FILE in "$@";
    do
        if ! ${CLI_SUBSHELL_TEMP_FILE_BASHPID[${FILE}]-}; then
            continue;
        fi;
        unset "CLI_SUBSHELL_TEMP_FILE_BASHPID[${FILE}]";
        if [[ ! -a "${FILE}" ]]; then
            :;
        else
            if [[ -d "${FILE}" ]]; then
                rm -f -r "${FILE}";
                rm -f -r "${FILE}";
            else
                rm -f "${FILE}";
            fi;
        fi;
    done
}
