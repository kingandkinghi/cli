cli::core::type::resolve () 
{ 
    local TYPE="${1-}";
    [[ "${TYPE}" =~ $CLI_CORE_REGEX_TYPE_NAME ]] || cli::assert "Expected type name to match '${CLI_CORE_REGEX_TYPE_NAME}', but got '${TYPE}'.";
    REPLY="CLI_TYPE_${TYPE^^}"
}
