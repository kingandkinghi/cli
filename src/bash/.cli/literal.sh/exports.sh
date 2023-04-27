cli::bash::literal () 
{ 
    local literal="$*";
    if [[ "${literal}" =~ ^[a-zA-Z0-9_-]*$ ]]; then
        echo "${literal}";
        return 0;
    fi;
    local ARRAY=("$*");
    literal=$(declare -p ARRAY);
    literal="${literal:22}";
    literal="${literal:0: -1}";
    echo "${literal}"
}
