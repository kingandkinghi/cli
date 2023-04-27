cli::source cli bash yield
cli::bash::map::keys () 
{ 
    local -n MAP_REF=${1?'Missing map.'};
    cli::bash::yield "${!MAP_REF[@]}" | sort
}
