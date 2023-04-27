cli::source cli bash variable get-info
cli::source cli core type resolve
cli::core::type::get () 
{ 
    cli::core::type::resolve "${1-}";
    local TYPE_NAME="${REPLY}";
    cli::bash::variable::get_info "${TYPE_NAME}" || cli::assert "Expected type '$@' to be declared as '${TYPE_NAME}', but actually not.";
    REPLY="${TYPE_NAME}"
}
