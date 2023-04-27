cli::bash::variable::declare_enum () 
{ 
    declare NAME=$1;
    shift;
    declare -gra "${NAME}=( $* )";
    local COUNT=$#;
    for ((i=0; i<${COUNT}; i++))
    do
        declare -gr "${NAME}_$1=$i";
        shift;
    done
}
