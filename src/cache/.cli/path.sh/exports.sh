cli::source cli path dir
cli::source cli path name
cli::cache::path () 
{ 
    cli::path::name "$1";
    local NAME="${REPLY}";
    cli::path::dir "$1";
    local DIR="${REPLY}";
    REPLY="${DIR}/.cli/${NAME}"
}
