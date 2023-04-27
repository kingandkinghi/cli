cli::bash::printf () 
{ 
    local FORMAT=${1-};
    [[ -n "{FORMAT}" ]] || cli::assert 'Missing format.';
    shift;
    if (( $# == 0 )); then
        return;
    fi;
    printf "${FORMAT}" "$@"
}
