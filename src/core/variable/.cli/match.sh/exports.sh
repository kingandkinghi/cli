cli::source cli bash filter glob
cli::source cli bash map keys
cli::core::variable::match () 
{ 
    : "${ARG_SCOPE?'Missing scope.'}";
    cli::bash::map::keys ${ARG_SCOPE} | cli::bash::filter::glob "$@"
}
