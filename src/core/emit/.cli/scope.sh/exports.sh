cli::source cli bash emit expression map
cli::source cli core variable get-info
cli::core::emit::scope () 
{ 
    : "${ARG_SCOPE?'Missing scope.'}";
    local -A CLI_CORE_VARIABLE_EMIT_SCOPE=();
    while read NAME; do
        cli::core::variable::get_info "${NAME}";
        CLI_CORE_VARIABLE_EMIT_SCOPE+=([${NAME}]="${REPLY}");
    done;
    echo -n "CLI_SCOPE+=";
    cli::bash::emit::expression::map CLI_CORE_VARIABLE_EMIT_SCOPE;
    echo
}
