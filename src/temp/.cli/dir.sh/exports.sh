cli::source cli temp file
cli::temp::dir () 
{ 
    cli::temp::file "$@";
    rm -f "${REPLY}";
    mkdir "${REPLY}"
}
