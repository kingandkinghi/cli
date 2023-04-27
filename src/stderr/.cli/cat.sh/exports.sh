cli::source cli stderr lock
cli::source cli temp file
cli::stderr::cat () 
{ 
    cli::temp::file;
    local SCRATCH="${REPLY}";
    cat > "${SCRATCH}";
    cat "${SCRATCH}" | cli::stderr::lock 1>&2;
    rm "${SCRATCH}"
}
