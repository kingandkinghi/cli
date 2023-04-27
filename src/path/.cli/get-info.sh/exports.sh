cli::path::get_info () 
{ 
    REPLY_CLI_PATH_EXISTS=false;
    REPLY_CLI_PATH_IS_FILE=false;
    REPLY_CLI_PATH_IS_DIRECTORY=false;
    REPLY_CLI_PATH_IS_EXECUTABLE=false;
    REPLY_CLI_PATH_IS_WRITABLE=false;
    REPLY_CLI_PATH_IS_SYMBOLIC_LINK=false;
    if [[ ! -n "${1-}" || ! -e "${1}" ]]; then
        return;
    fi;
    REPLY_CLI_PATH_EXISTS=true;
    if [[ -f "${1}" ]]; then
        REPLY_CLI_PATH_IS_FILE=true;
    else
        if [[ -d "${1}" ]]; then
            REPLY_CLI_PATH_IS_DIRECTORY=true;
        else
            if [[ -L "${1}" ]]; then
                REPLY_CLI_PATH_IS_SYMBOLIC_LINK=true;
            fi;
        fi;
    fi;
    if [[ -w "${1}" ]]; then
        REPLY_CLI_PATH_IS_WRITABLE=true;
    fi;
    if [[ -x "${1}" ]]; then
        REPLY_CLI_PATH_IS_EXECUTABLE=true;
    fi
}
