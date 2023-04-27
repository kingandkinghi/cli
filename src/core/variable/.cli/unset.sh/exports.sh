cli::source cli core variable children
cli::core::variable::unset () 
{ 
    [[ -n ${ARG_SCOPE} ]] || cli::assert 'Missing scope.';
    local -n SCOPE_REF=${ARG_SCOPE};
    while (( $# > 0 )); do
        local NAME="$1";
        shift;
        cli::core::variable::children ${NAME};
        cli::core::variable::unset "${MAPFILE[@]}";
        unset "SCOPE_REF[${NAME}]";
        unset ${NAME};
    done
}
