cli::bash::write () 
{ 
    MAPFILE=();
    local COUNT=$#;
    while (( $# > 0 )); do
        local field="$1";
        if [[ ! -n "${field}" ]]; then
            IFS=;
            [[ ! -n "$*" ]] || cli::assert "Arguments to write must not be empty unless they all appear last.";
            IFS="${CLI_IFS}";
            break;
        fi;
        field="${field//\\/\\\\}";
        field="${field// /\\ }";
        field="${field//'	'/\\'	'}";
        MAPFILE+=("${field}");
        shift;
    done;
    echo "${MAPFILE[@]}"
}
