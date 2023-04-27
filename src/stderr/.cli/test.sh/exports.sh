cli::source cli stderr fail
cli::stderr::test () 
{ 
    diff <( set -m; ! ( set +m; ( eval "$1" 2>&1 ); cli::assert ) || cli::assert ) - <<< "$2"
}
