#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli bash write"
    "cli core type get"
    "cli core variable get-info"
    "cli core variable resolve"
)

cli::core::variable::write::help() {
    cat << EOF
Command
    cli core variable write
    
Summary
    Write a variable's fields as a sequence of records.

Description
    Argument \$1 is the variable whose fields are to be copied to stdout
    as records consisting of field names followed by the field value.
EOF
    cat << EOF

Examples
    For example, writing a variable VAR of type 'metadata' defined as 
    
        CLI_TYPE_METADATA=(
            [positional]=boolean
            [allow]='map_of map'
        )
        
    where 'positional' is 'true' and 'allow' is has a key 'color' which points at a 
    map whose keys are 'black' and 'white' and whose values are empty:

        VAR_POSITIONAL=true
        VAR_ALLOW=( [0]='color' )
        VAR_ALLOW_0=(
            [black]=
            [white]=
        )

    would produce the following records: 

        allow color black
        allow color white
        positional true
EOF
}

cli::core::variable::json::write() {
    local ARG_SCOPE=${ARG_SCOPE-'CLI_SCOPE'}
    local NAME="${1-}"

    # check NAME in ARG_SCOPE
    cli::core::variable::get_info "${NAME}" \
        || cli::assert "Variable '${NAME}' not found in scope."
    local TYPE="${MAPFILE[*]}"

    # private stack
    local PREFIX_NAME=CLI_CORE_VARIABLE_JSON_WRITE_PREFIX
    local -n PREFIX=CLI_CORE_VARIABLE_JSON_WRITE_PREFIX

    # leaf
    if ${REPLY_CLI_CORE_VARIABLE_IS_BUILTIN}; then
        local -n REF=${NAME}

        # boolean
        if ${REPLY_CLI_CORE_VARIABLE_IS_BOOLEAN}; then

            if ${REF}; then
                printf '%s' "true"
            else
                printf '%s' "false"
            fi

        # scaler
        elif ${REPLY_CLI_CORE_VARIABLE_IS_INTEGER}; then
            printf '%s' "${REF}"

        # scaler
        elif ${REPLY_CLI_CORE_VARIABLE_IS_SCALER}; then
            printf '"%s"' "${REF}"

        # array
        elif ${REPLY_CLI_CORE_VARIABLE_IS_ARRAY}; then
            printf "["
            local VALUE
            local COMMA=
            for VALUE in "${REF[@]}"; do
                printf '%s"%s"' "${COMMA}" "${VALUE}"
                COMMA=','
            done
            printf "]"

        # map
        else
            ${REPLY_CLI_CORE_VARIABLE_IS_MAP} || cli::assert
            printf "{"
            local KEY
            local COMMA=
            for KEY in ${!REF[@]}; do
                printf '%s"%s":"%s"' "${COMMA}" "${KEY}" "${REF[$KEY]}"
                COMMA=','
            done
            printf "}"
        fi

    else
        local -a SEGMENTS

        # anonymous
        if ${REPLY_CLI_CORE_VARIABLE_IS_MODIFIED}; then
            local -n ORDINALS_REF=${NAME}
            SEGMENTS=( "${!ORDINALS_REF[@]}" )

        # udt
        else
            ${REPLY_CLI_CORE_VARIABLE_IS_USER_DEFINED} || cli::assert
            local USER_DEFINED_TYPE="${REPLY}"

            cli::core::type::get "${USER_DEFINED_TYPE}"

            local -n TYPE_REF="${REPLY}"
            SEGMENTS=( "${!TYPE_REF[@]}" )
        fi

        local -a PREFIX_COPY=( "${PREFIX[@]}" )

        printf '{'
        local SEGMENT
        local COMMA=
        for SEGMENT in "${SEGMENTS[@]}"; do
            local -a CLI_CORE_VARIABLE_JSON_WRITE_PREFIX=( "${PREFIX_COPY[@]}" "${SEGMENT}" )
            cli::core::variable::resolve "${NAME}" "${SEGMENT}"
            printf '%s"%s":' "${COMMA}" "${SEGMENT}"
            COMMA=','
            cli::core::variable::json::write "${REPLY}"
        done
        printf '}'
    fi
}

cli::core::variable::json::write::self_test() {
    ARG_SCOPE='SCOPE'

    # builtin
    local -A SCOPE=(
        ['MY_STRING']='string'
        ['MY_INTEGER']='integer'
        ['MY_BOOLEAN']='boolean'
        ['MY_MAP']='map'
        ['MY_ARRAY']='array'
    )

    # string
    local MY_STRING='Hello World!'
    diff <(cli core variable json write -- MY_STRING; echo) - <<< '"Hello World!"'

    # integer
    local -i MY_INTEGER=42
    diff <(cli core variable json write -- MY_INTEGER; echo) - <<< '42'

    # boolean true
    local MY_BOOLEAN=true
    diff <(cli core variable json write -- MY_BOOLEAN; echo) - <<< 'true'

    # boolean false
    local MY_BOOLEAN=false
    diff <(cli core variable json write -- MY_BOOLEAN; echo) - <<< 'false'

    # array
    local -a MY_ARRAY=( 'a a b a' )
    diff <(cli core variable json write -- MY_ARRAY; echo) - <<< '["a a b a"]'

    # array
    local -a MY_ARRAY=( a a b a )
    diff <(cli core variable json write -- MY_ARRAY; echo) - <<< '["a","a","b","a"]'

    # map
    local -A MY_MAP=( [key]=value [element]= )
    diff <(cli core variable json write -- MY_MAP | jq --sort-keys) \
        <(echo '{"key":"value","element":""}' | jq --sort-keys)

    # map_of map
    local -A SCOPE=(
        ['MOD_MAP']='map_of map'
        ['MOD_MAP_0']='map'
    )
    local -A MOD_MAP=(
        ['seq']=0
    )
    local -A MOD_MAP_0=(
        ['pi']=3141
        ['fib']=11235
    )
    diff <(cli core variable json write -- MOD_MAP | jq --sort-keys) \
        <(echo '{"seq":{"pi":"3141","fib":"11235"}}' | jq --sort-keys)
    
    # map_of map_of integer
    local -A SCOPE=(
        ['MOD_MOD_INTEGER']='map_of map_of integer'
        ['MOD_MOD_INTEGER_0']='map_of integer'
        ['MOD_MOD_INTEGER_0_0']='integer'
        ['MOD_MOD_INTEGER_0_1']='integer'
    )
    local -A MOD_MOD_INTEGER=(
        ['seq']=0
    )
    local -A MOD_MOD_INTEGER_0=(
        ['fib']=0
        ['pi']=1
    )
    local -A MOD_MOD_INTEGER_0_0=11235
    local -A MOD_MOD_INTEGER_0_1=3141
    diff <(cli core variable json write -- MOD_MOD_INTEGER | jq --sort-keys) \
        <(echo '{"seq":{"pi":3141,"fib":11235}}' | jq --sort-keys)

    # map_of array
    local -A SCOPE=(
        ['MOD_ARRAY']='map_of array'
        ['MOD_ARRAY_0']='array'
    )
    local -A MOD_ARRAY=(
        ['seq']=0
    )
    local -a MOD_ARRAY_0=( 'fib' 'pi' )
    diff <(cli core variable json write -- MOD_ARRAY; echo) \
        <(echo '{"seq":["fib","pi"]}')

    # udt
    local -A SCOPE=(
        ['META']='metadata'
        ['META_NEVER']='boolean'
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
    local -A CLI_TYPE_VERSION=(
        ['major']=integer
        ['minor']=integer
    )
    local -A CLI_TYPE_METADATA=(
        ['allow']='map_of map'
        ['mmm']='map_of map_of map'
        ['positional']='boolean'
        ['never']='boolean'
        ['version']='version'
    )

    local META_NEVER=false
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
    diff <(cli core variable json write -- META | jq --sort-keys) - <<-EOF
		{
		  "allow": {
		    "color": {
		      "black": "",
		      "white": ""
		    }
		  },
		  "mmm": {
		    "a": {
		      "b": {
		        "c": "d"
		      }
		    }
		  },
		  "never": false,
		  "positional": true,
		  "version": {
		    "major": 1,
		    "minor": 2
		  }
		}
		EOF
}
