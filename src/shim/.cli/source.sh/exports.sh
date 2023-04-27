cli::source cli bash function is-declared
cli::source cli bash which
cli::shim::source () 
{ 
    local NAME="${1-}";
    shift;
    [[ -n ${NAME} ]] || cli::assert 'Missing shim name.';
    if declare -F "${NAME}" > /dev/null; then
        return;
    fi;
    cli::bash::which "${NAME}" || cli::assert "Failed to find shim '${NAME}' on the path.";
    source "${REPLY}";
    cli::bash::function::is_declared "${NAME}" || cli::assert "Shim '${NAME}' failed to define function ${NAME}."
}
