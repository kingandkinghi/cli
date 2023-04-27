cli::source cli bash stack call
cli::source cli bash stack process
cli::bash::stack::trace () 
{ 
    cli::bash::stack::call;
    if [[ -n "${CLI_STACK_SHOW_PROCESS-}" ]]; then
        cli::bash::stack::process;
    fi
}
