cli::bash::variable::list () 
{ 
    local NAME;
    for NAME in "$@";
    do
        if [[ ! -n "${NAME}" ]]; then
            continue;
        else
            if [[ "${NAME}" =~ ^.*[*]$ ]]; then
                local MATCH;
                for MATCH in $(eval "echo \${!${NAME}}");
                do
                    echo "${MATCH}";
                done;
            else
                if [[ -v "${NAME}" ]]; then
                    echo "${NAME}";
                else
                    local MATCH;
                    for MATCH in $(eval "echo \${!${NAME}*}");
                    do
                        if [[ "${MATCH}" == "${NAME}" ]]; then
                            echo "${NAME}";
                        fi;
                    done;
                fi;
            fi;
        fi;
    done | sort
}
