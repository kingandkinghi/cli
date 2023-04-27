cli::bash::filter::glob () 
{ 
    while read -r; do
        local FILTER;
        for FILTER in "$@";
        do
            if [[ "${REPLY}" == ${FILTER} ]]; then
                echo "${REPLY}";
                break;
            fi;
        done;
    done
}
