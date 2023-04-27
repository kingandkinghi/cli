cli::bash::function::is_declared () 
{ 
    declare -F "${1-}" > /dev/null
}
