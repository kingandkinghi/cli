cli::path::make_absolute () 
{ 
    if [[ ! -n "${1-}" ]]; then
        REPLY="${PWD}";
    else
        if [[ ! "$1" =~ ^/ ]]; then
            REPLY="${PWD}/${1##./}";
        else
            REPLY="$1";
        fi;
    fi
}
