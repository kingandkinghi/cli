cli::cache::test () 
{ 
    local CACHE="$1";
    shift;
    if [[ ! -f "${CACHE}" ]]; then
        return 1;
    fi;
    while (( $# > 0 )); do
        local SOURCE="$1";
        shift;
        if [[ ! "${SOURCE}" -ot "${CACHE}" ]]; then
            return 1;
        fi;
    done
}
