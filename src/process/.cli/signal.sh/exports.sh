cli::source cli process get-info
cli::process::signal () 
{ 
    local SIGNAL=${1-SIGINT};
    cli::process::get_info;
    kill "-${SIGNAL}" "-${REPLY_CLI_PROCESS_GROUP_ID}"
}
