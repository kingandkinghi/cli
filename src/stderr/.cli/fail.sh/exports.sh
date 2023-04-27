cli::source cli stderr dump
cli::source cli temp file
cli::source cli stderr message
cli::stderr::fail () 
{ 
    echo "$*" | cli::stderr::dump
}
