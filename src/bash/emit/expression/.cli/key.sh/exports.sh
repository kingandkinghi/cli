cli::source cli bash key literal
cli::bash::emit::expression::key () 
{ 
    echo -n "[";
    cli::bash::key::literal "$1";
    echo -n "${REPLY}";
    echo -n "]"
}
