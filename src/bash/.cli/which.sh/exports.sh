cli::source cli path get-info
cli::bash::which () 
{ 
    MAPFILE=();
    local NAME="$1";
    shift;
    local IFS=:;
    local -a DIRS=(${PATH});
    for dir in "${DIRS[@]}";
    do
        local PROBE="${dir}/${NAME}";
        MAPFILE+=("${PROBE}");
        cli::path::get_info "${PROBE}";
        if ${REPLY_CLI_PATH_IS_EXECUTABLE}; then
            REPLY="${PROBE}";
            return 0;
        fi;
    done;
    return 1
}
