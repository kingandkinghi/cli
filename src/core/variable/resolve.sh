#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli core variable get-info"
    "cli core variable name resolve"
)

cli::core::variable::resolve::help() {
    cat << EOF
Command
    cli core variable resolve
    
Summary
    Return a bash variable name given a bash variable and a string of fields.

Description
    Argument \$1 is the root uppercase bash variable name. Remaining arguments 
    are lower case field names. 

    ARG_SCOPE is a map of bash variable names to their core type.

    REPLY is the resolved bash name.
    MAPFILE is the type of the resolved bash name.
EOF
}

cli::core::variable::resolve() {
    local NAME="${1-}"
    [[ "${NAME}" ]] || cli::assert 'Missing name.'

    cli::core::variable::get_info "${NAME}" \
        || cli::assert "Variable '${NAME}' not found."
    local TYPE="${MAPFILE[*]}"

    ARG_TYPE="${TYPE}" \
        cli::core::variable::name::resolve "$@"
}

cli::core::variable::resolve::test() {
    cli::core::variable::resolve "$@"
    echo "${MAPFILE[*]} ${REPLY}"
}

cli::core::variable::resolve::self_test() {
    ARG_SCOPE='SCOPE'

    # builtin
    local -A SCOPE=(
        ['MY_STRING']='string' 
        ['MY_INTEGER']='integer'
        ['MY_BOOLEAN']='boolean'
        ['MY_MAP']='map'
        ['MY_ARRAY']='array'
    )
    diff <(cli::core::variable::resolve::test MY_STRING) - <<< 'string MY_STRING'
    diff <(cli::core::variable::resolve::test MY_INTEGER) - <<< 'integer MY_INTEGER'
    diff <(cli::core::variable::resolve::test MY_BOOLEAN) - <<< 'boolean MY_BOOLEAN'
    diff <(cli::core::variable::resolve::test MY_MAP) - <<< 'map MY_MAP'
    diff <(cli::core::variable::resolve::test MY_ARRAY) - <<< 'array MY_ARRAY'
    
    # modified array
    local -A SCOPE=(
        ['VAR']='map_of array'
    )
    local -A VAR=(
        ['seq']=0
    )
    diff <(cli::core::variable::resolve::test VAR seq) - <<< 'array VAR_0'

    # modified integer
    local -A SCOPE=(
        ['VAR']='map_of map_of integer'
    )
    local -A VAR=(
        ['seq']=0
    )
    local -A VAR_0=(
        ['fib']=0
        ['pi']=1
    )
    local -A VAR_0_0=11235
    local -A VAR_0_1=3141

    diff <(cli::core::variable::resolve::test VAR) - <<< 'map_of map_of integer VAR'
    diff <(cli::core::variable::resolve::test VAR seq) - <<< 'map_of integer VAR_0'
    diff <(cli::core::variable::resolve::test VAR seq fib) - <<< 'integer VAR_0_0'
    diff <(cli::core::variable::resolve::test VAR seq pi) - <<< 'integer VAR_0_1'

    # user defined type
    local -A CLI_TYPE_VERSION=(
        ['major']=integer
        ['minor']=integer
    )
    local -A CLI_TYPE_METADATA=(
        ['allow']='map_of map'
        ['mmm']='map_of map_of map'
        ['positional']='boolean'
        ['version']='version'
    )

    local -A SCOPE=(
        ['META']='metadata'
        ['META_POSITIONAL']='boolean'
        ['META_VERSION']='version'
        ['META_VERSION_MAJOR']='integer'
        ['META_VERSION_MINOR']='integer'
        ['META_ALLOW']='map_of map'
        ['META_ALLOW_0']='map'
        ['META_MMM']='map_of map_of map'
        ['META_MMM_0']='map_of map'
        ['META_MMM_0_0']='map'
    )
    local META_POSITIONAL=true
    local -i META_VERSION_MAJOR=1
    local -i META_VERSION_MINOR=2
    local -A META_ALLOW=(
        ['color']=0
    )
    local -A META_ALLOW_0=(
        ['black']=
        ['white']=
    )
    local -A META_MMM=(
        ['a']=0
    )
    local -A META_MMM_0=(
        ['b']=0
    )
    local -A META_MMM_0_0=(
        ['c']='d'
    )

    diff <(cli::core::variable::resolve::test META allow color) - <<< 'map META_ALLOW_0'
    diff <(cli::core::variable::resolve::test META mmm a b) - <<< 'map META_MMM_0_0'
    diff <(cli::core::variable::resolve::test META positional) - <<< 'boolean META_POSITIONAL'
    diff <(cli::core::variable::resolve::test META version) - <<< 'version META_VERSION'
    diff <(cli::core::variable::resolve::test META version major) - <<< 'integer META_VERSION_MAJOR'
    diff <(cli::core::variable::resolve::test META version minor) - <<< 'integer META_VERSION_MINOR'
}
