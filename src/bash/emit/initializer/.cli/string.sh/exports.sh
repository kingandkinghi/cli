cli::source cli bash string literal
cli::bash::emit::initializer::string () 
{ 
    [[ -n ${1:-} ]] || cli::assert 'Missing string variable name.';
    local -n REF=${1-};
    cli::bash::string::literal "${REF}";
    echo -n "${REPLY}"
}
