cli::source cli core type get-info
cli::core::type::unmodify () 
{ 
    MAPFILE=();
    cli::core::type::get_info "$@";
    if ! $REPLY_CLI_CORE_TYPE_IS_MODIFIED; then
        MAPFILE=("$@");
        return 1;
    fi;
    set $@;
    shift;
    MAPFILE=("$@")
}
