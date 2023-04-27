cli::source cli bash stack trace
cli::source cli stderr dump
cli::stderr::assert () 
{ 
    if (( $# == 0 )); then
        set 'Condition failed';
    fi;
    { 
        echo "ASSERT FAILED:" "$*";
        cli::bash::stack::trace | sed 's/^/  /'
    } | cli::stderr::dump
}
