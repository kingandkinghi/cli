cli::source cli bash join
cli::source cli name to-bash
cli::name::to_function () 
{ 
    cli::name::to_bash "$@";
    cli::bash::join "::" "${MAPFILE[@]}"
}
