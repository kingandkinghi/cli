cli::run_as () 
{ 
    local -a args=($(printf %q "${arg_command}"));
    for i in "$@";
    do
        args+=($(printf %q "${i}"));
    done;
    sudo su "${arg_user}" -c "${args[*]}"
}
