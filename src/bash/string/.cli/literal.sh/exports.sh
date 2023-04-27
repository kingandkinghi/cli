cli::bash::string::literal () 
{ 
    local LITERAL="$*";
    if [[ "${LITERAL}" =~ ^[a-zA-Z0-9_-]*$ ]]; then
        REPLY="\"${LITERAL}\"";
        return 0;
    fi;
    local ARRAY=("$*");
    LITERAL=$(declare -p ARRAY);
    LITERAL="${LITERAL:22}";
    LITERAL="${LITERAL:0: -1}";
    REPLY="${LITERAL}"
}
