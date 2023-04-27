cli::bash::stack::process () 
{ 
    local ARG_START_PID=${1-$$};
    local ARG_END_PID=${2-${CLI_PID-}};
    local -a pid_parent=();
    local -a pid_cmd=();
    while read pid ppid cmd; do
        pid_parent[${pid}]=${ppid};
        pid_cmd[${pid}]="${cmd}";
    done < <(ps -o pid=,ppid=,args=);
    local pid=${BASHPID};
    local -a subshell=(${BASHPID});
    while (( $pid != $$ )); do
        echo "(${pid}) subshell";
        pid=${pid_parent[${pid}]};
    done;
    local pid=${ARG_START_PID};
    for ((i=0; ${pid} > 0; i++ ))
    do
        echo -n "(${pid}) ";
        local inline_args=${pid_cmd[${pid}]};
        if (( ${#inline_args} < 80 )); then
            echo "${inline_args}";
        else
            echo "${inline_args}" | sed -e 's/--/\
  --/g';
        fi;
        if (( ${pid} == ${ARG_END_PID-0} )); then
            break;
        fi;
        pid=${pid_parent[${pid}]-0};
    done
}
