cli::source cli bash string literal
cli::bash::key::literal () 
{ 
    local LITERAL="$*";
    if [[ "${LITERAL}" =~ ^[a-zA-Z0-9_-]*$ ]]; then
        REPLY="${LITERAL}";
        return 0;
    fi;
    local -A MAP=(["$*"]=);
    LITERAL=$(declare -p MAP);
    LITERAL="${LITERAL:17}";
    LITERAL="${LITERAL:0: -6}";
    REPLY="${LITERAL}"
}
