cli::bash::join () 
{ 
    local DELIMITER=${1?'Missing delimiter'};
    shift;
    REPLY="";
    while (( $# > 0 )); do
        REPLY+="$1";
        shift;
        if (( $# > 0 )); then
            REPLY+="${DELIMITER}";
        fi;
    done
}
