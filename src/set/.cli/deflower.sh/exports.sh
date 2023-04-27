cli::source cli set test
cli::set::deflower () 
{ 
    local -n SET_REF=${1?'Missing set'};
    local KEY=${2?'Missing element value'};
    if cli::set::test "$@"; then
        return 1;
    fi;
    SET_REF[${KEY}]=true
}
