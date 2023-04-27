cli::bash::array::pop () 
{ 
    (( $# > 0 )) || cli::assert 'Stack empty.';
    MAPFILE=(${@:1:$((${#@}-1))})
}
