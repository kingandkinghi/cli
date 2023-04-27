cli::stderr::lock () 
{ 
    flock -x "${CLI_LOADER_LOCK}" cat
}
