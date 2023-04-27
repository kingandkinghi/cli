cli::source cli bash variable list
cli::bash::variable::emit () 
{ 
    cli::bash::variable::list "$@" | while read; do
        declare -p ${REPLY};
    done
}
