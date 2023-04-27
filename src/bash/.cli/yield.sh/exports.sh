cli::bash::yield () 
{ 
    while (( $# > 0 )); do
        echo "$1";
        shift;
    done
}
