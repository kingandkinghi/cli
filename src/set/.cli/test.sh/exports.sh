cli::set::test () 
{ 
    local -n SET_REF=${1:?'Missing set'};
    shift;
    local KEY="$*";
    [[ -n "${KEY}" ]] || cli::assert 'Missing key';
    [[ ${SET_REF[${KEY}]+hit} == 'hit' ]]
}
