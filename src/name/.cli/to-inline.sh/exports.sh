cli::source cli bash join
cli::source cli name to-bash
cli::name::to_inline () 
{ 
    cli::name::to_bash "$@";
    cli::bash::join '::' "${MAPFILE[@]}"
}
