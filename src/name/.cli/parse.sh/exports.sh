cli::name::parse () 
{ 
    MAPFILE=();
    while [[ "${1-}" =~ ${CLI_REGEX_NAME} ]]; do
        MAPFILE+=("$1");
        shift;
    done
}
