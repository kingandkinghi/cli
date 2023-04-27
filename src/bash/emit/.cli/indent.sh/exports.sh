cli::bash::emit::indent () 
{ 
    local PREFIX="${1-}";
    local FIRST=true;
    local EMIT_TAB="    ";
    local REGEX='<< ([A-Z]+)';
    local EOF=;
    while read -r; do
        if ${FIRST} && [[ -n "${PREFIX}" ]]; then
            echo -n "${PREFIX}";
        fi;
        FIRST=false;
        if [[ "${REPLY}" =~ ${REGEX} ]]; then
            echo "${EMIT_TAB}${REPLY}";
            EOF=${BASH_REMATCH[1]};
            while read -r; do
                echo "${REPLY}";
                if [[ "${REPLY}" == "${EOF}" ]]; then
                    break;
                fi;
            done;
            continue;
        fi;
        echo "${EMIT_TAB}${REPLY}";
    done
}
