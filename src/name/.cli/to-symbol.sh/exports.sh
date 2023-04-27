cli::source cli bash join
cli::source cli name to-bash
cli::name::to_symbol () 
{ 
    cli::name::to_bash "$@";
    cli::bash::join '_' "${MAPFILE[@]^^}"
}
