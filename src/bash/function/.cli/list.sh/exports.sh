cli::source cli bash filter glob
cli::bash::function::list () 
{ 
    declare -F | awk '{ print $3 }' | cli::bash::filter::glob "$@"
}
