cli::source cli temp file
cli::temp::fifo () 
{ 
    cli::temp::file "$@";
    rm -f "${REPLY}";
    mkfifo "${REPLY}"
}
