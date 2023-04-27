cli::source cli core variable declare
cli::source cli core variable put
cli::core::variable::read () 
{ 
    local ARG_SCOPE=${ARG_SCOPE-'CLI_SCOPE'};
    local NAME="$1";
    while read -a MAPFILE; do
        cli::core::variable::put "${NAME}" "${MAPFILE[@]}";
    done
}
