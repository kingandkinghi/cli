cli::source cli core type get-info
cli::source cli core type unmodify
cli::core::type::unmodified () 
{ 
    MAPFILE=("$@");
    while cli::core::type::unmodify "${MAPFILE[@]}"; do
        :;
    done;
    REPLY=${MAPFILE}
}
