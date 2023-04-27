cli::source cli path dir
cli::source cli temp file
cli::cache::put () 
{ 
    local CACHE="$1";
    cli::path::dir "${CACHE}";
    local DIR="${REPLY}";
    mkdir -p "${DIR}";
    cli::temp::file;
    local TEMP="${REPLY}";
    cat > "${TEMP}";
    mv "${TEMP}" "${CACHE}";
    REPLY="${CACHE}"
}
