cli::source cli attribute is-defined
cli::source cli bash literal
cli::bash::stack::call () 
{ 
    set -- ${BASH_ARGV[@]};
    local -i argc=0;
    for ((i=0; i<${#FUNCNAME[@]}; i++ ))
    do
        local -a args=();
        local inline_args='';
        local funcname="${FUNCNAME[$i]}";
        if (( i == ${#FUNCNAME[@]}-1 )); then
            funcname='bash::main';
        fi;
        for ((j=${BASH_ARGC[$i]}-1; j>=0; j-- ))
        do
            args+=("$(cli::bash::literal "${BASH_ARGV[${j}+${argc}]}")");
        done;
        argc+=${BASH_ARGC[$i]};
        if [[ ! -n "${CLI_STACK_SHOW_HIDDEN-}" ]] && cli::attribute::is_defined 'METHOD' "${funcname}" 'cli_bash_stack_hidden_attribute'; then
            continue;
        fi;
        inline_args="${args[@]}";
        if (( ${#inline_args} > 80 )); then
            inline_args=;
        else
            args=();
        fi;
        printf '%-50s %s:%s\n' "${funcname} ${inline_args}" "${BASH_SOURCE[$i]}" ${BASH_LINENO[$i-1]-};
        for arg in "${args[@]}";
        do
            echo "${arg}";
        done | sed 's/^/  /';
    done
}
