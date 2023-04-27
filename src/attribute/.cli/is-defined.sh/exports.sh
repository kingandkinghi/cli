cli::attribute::is_defined () 
{ 
    local target_type=${1-};
    shift;
    local target=${1-};
    shift;
    local type=${1-};
    shift;
    [[ ${target_type} == 'METHOD' ]] || cli::assert;
    [[ ${target} != 'METHOD' ]] || [[ ${target} =~ ${CLI_REGEX_BASH_NAME} ]] || cli::assert;
    local -n targets="CLI_META_ATTRIBUTES_${target_type}";
    local index=${targets[${target}]:-};
    local -n ref="CLI_META_ATTRIBUTES_${target_type}_${index}_TYPE";
    for attribute in "${ref[@]}";
    do
        if [[ "${attribute}" == "${type}" ]]; then
            return 0;
        fi;
    done;
    return 1
}
