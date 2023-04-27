cli::name::to_bash () 
{ 
    MAPFILE=();
    while (( $# > 0 )); do
        [[ "$1" =~ ${CLI_REGEX_NAME} ]] || cli::assert "Unexpected cli name \"$1\" does not match regex ${CLI_REGEX_NAME}.";
        MAPFILE+=("${1//[-.]/_}");
        shift;
    done;
    REPLY=${MAPFILE[0]}
}
