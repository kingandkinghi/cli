cli::source cli set test
cli::set::intersect () 
{ 
    declare -gA REPLY_MAP=();
    local SET0_NAME=$1;
    local SET1_NAME=$2;
    local -n SET0_REF=${SET0_NAME?'Missing set.'};
    local -n SET1_REF=${SET1_NAME?'Missing set.'};
    local ELEMENT;
    for ELEMENT in "${!SET0_REF[@]}";
    do
        if cli::set::test ${SET1_NAME} "${ELEMENT}"; then
            REPLY_MAP["${ELEMENT}"]=;
        fi;
    done
}
