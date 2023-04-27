cli::source cli core variable get-info
cli::source cli core variable name resolve
cli::core::variable::resolve () 
{ 
    local NAME="${1-}";
    [[ -n "${NAME}" ]] || cli::assert 'Missing name.';
    cli::core::variable::get_info "${NAME}" || cli::assert "Variable '${NAME}' not found.";
    local TYPE="${MAPFILE[*]}";
    ARG_TYPE="${TYPE}" cli::core::variable::name::resolve "$@"
}
