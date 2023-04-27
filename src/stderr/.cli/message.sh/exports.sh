cli::source cli stderr cat
cli::source cli process signal
cli::stderr::message () 
{ 
    local CHAR="$1";
    shift;
    local THOUSAND=1024;
    local INDEX;
    local THOUSAND_CHARS=$(
        for ((INDEX=0; INDEX<${THOUSAND}; INDEX++)); do 
            printf "${CHAR}"
        done
    );
    for ((INDEX=0; INDEX<${THOUSAND}; INDEX++))
    do
        { 
            echo ${THOUSAND_CHARS}
        };
    done
}
