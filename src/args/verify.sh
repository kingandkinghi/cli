#!/usr/bin/env CLI_NAME=cli bash-cli-part
CLI_IMPORT=(
    "cli args check"
    "cli args resolve"
    "cli core variable declare"
    "cli core variable put"
    "cli core variable read"
    "cli core variable write"
    "cli set intersect"
)

cli::args::verify::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Check command line arguments against constraints declared in help.

Description
    Consume a stream of 'cli_args' from stdin as would be generated by 'cli args parse'
    and a stream of 'map_of cli_meta_group' as would be generated by 'cli dsl load' as a fd 
    passed as the first positional argument, and ensure the former conforms to constraints 
    specified in the latter.

    'STRUCT_META' either has a single key '*' in which case there is only a single
    valid set of 'meta' to be used to parse a command line, or it has many keys
    each of which is a discriminating OPTION name which determines the 'meta' to be
    used to parse all remaining arguments. For example, many CLI accept two ways of
    identifying a target resource: 'id' and 'name' + 'namespace'. In that case, 'id'
    and 'name' could be used as discriminating options, and only when 'name' is
    specified is 'namespace' allowed.

Arguments
    --                      : Metadata stream.

EOF
    cat << EOF

Examples
    cli args tokenize -- --header foo --help \\
        | cli args parse \\
        | cli args check -- \\
            <( cli dsl sample ---load )
EOF
}

cli::args::verify::main() {
    cli::source cli args resolve

    ARG_TYPE='cli_args' \
        cli::core::variable::declare MY_ARGS
    cli::core::variable::read MY_ARGS

    ARG_META_GROUPS=${ARG_META}_GROUP \
        cli::args::resolve MY_ARGS
    local META_GROUP=${REPLY}

    ARG_META_GROUP=${META_GROUP} \
        cli::args::verify MY_ARGS

    cli::core::variable::write MY_ARGS
}

cli::args::verify() {
    : ${ARG_SCOPE?'Missing scope.'}

    : ${ARG_META_GROUP?'Missing metadata.'}
    local -n TYPE_REF=${ARG_META_GROUP}_TYPE
    local -n DEFAULT_REF=${ARG_META_GROUP}_DEFAULT
    local -n REQUIRE_REF=${ARG_META_GROUP}_REQUIRE
    local -n REGEX_REF=${ARG_META_GROUP}_REGEX
    local -n ALLOW_REF=${ARG_META_GROUP}_ALLOW
    local -n POSITIONAL_REF=${ARG_META_GROUP}_POSITIONAL

    local ARGS=${1?'Missing args.'}
    local -n POSITIONAL_ARGS_REF=${ARGS}_POSITIONAL
    local -n NAMED_ARGS_REF=${ARGS}_NAMED

    # trap for unknown named arguments
    local OPTION
    for OPTION in "${!NAMED_ARGS_REF[@]}"; do
        if [[ ! ${TYPE_REF[${OPTION}]+set} ]]; then
            cli::stderr::fail "Unexpected unknown argument '--${OPTION}'" \
                "passed to command '${CLI_COMMAND[@]}'."
        fi
    done

    # initialize name arguments
    for OPTION in ${!TYPE_REF[@]}; do

        # type
        local TYPE="${TYPE_REF[${OPTION}]}"

        # declare variable if not specified on command line
        if [[ ! "${NAMED_ARGS_REF[${OPTION}]+set}" ]]; then
            local DEFAULT=

            # fail if required and missing
            [[ ! ${REQUIRE_REF[$OPTION]+set} == 'set' ]] \
                || cli::stderr::fail "Missing required argument '--${OPTION}'" \
                    "in call to command '${CLI_COMMAND[@]}'."

            # switch has an explict default
            if [[ -n "${DEFAULT_REF[${OPTION}]+set}" ]] ; then
                DEFAULT=${DEFAULT_REF[${OPTION}]}

            # continue if switch is optional
            else
                continue
            fi

            # assign default if missing
            cli::core::variable::put ${ARGS} named "${OPTION}" "${DEFAULT}"
        fi

        local -n ARGS_NAMED_N_REF="${ARGS}_NAMED_${NAMED_ARGS_REF[$OPTION]}"

        # declared but empty
        if [[ -z "${ARGS_NAMED_N_REF-}" ]]; then

            # fail if required and empty
            if [[ -n ${REQUIRE_REF[$OPTION]+set} ]]; then
                cli::stderr::fail "Required argument '--${OPTION}'" \
                    "passed to command '${CLI_COMMAND[@]}' has empty value."
            fi
        fi

        # allow ref
        local ALLOW=''
        if [[ -n ${ALLOW_REF[$OPTION]+set} ]]; then 
            local -n allow_ref=${ARG_META_GROUP}_ALLOW_${ALLOW_REF[${OPTION}]}
            ALLOW="${!allow_ref[@]}"
        fi

        # element type & values
        local -a VALUES=()
        local ELEMENT_TYPE='string'
        local VALUE
        case "${TYPE}" in
            'array') VALUES=( "${ARGS_NAMED_N_REF[@]}" ) ;;
            'map') 
                for VALUE in "${ARGS_NAMED_N_REF[@]}"; do
                    if [[ ! "${VALUE}" =~ ${CLI_REGEX_PROPERTY_ARG} ]]; then
                        cli::stderr::fail "Unexpected value '${VALUE}' for argument '--${OPTION}'" \
                            "passed to command '${CLI_COMMAND[@]}'." \
                            "Expected a value that matches regex '${CLI_REGEX_PROPERTY_ARG}'."
                    fi
                    VALUES+=( ${BASH_REMATCH[2]} )
                done
                ;;
            *) 
                ELEMENT_TYPE="${TYPE}"
                VALUES=( "${ARGS_NAMED_N_REF[@]}" ) 
                ;;
        esac

        # check values
        for VALUE in "${VALUES[@]}"; do
            cli::args::check \
                "${OPTION}" \
                "${VALUE}" \
                "${ELEMENT_TYPE}" \
                "${REGEX_REF[${OPTION}]-}" \
                "${ALLOW}"
        done
    done

    # positional
    if ! ${POSITIONAL_REF} && (( ${#POSITIONAL_ARGS_REF[@]} > 0 )); then
        cli::stderr::fail "Expected no positional arguments passed to command '${CLI_COMMAND[@]}'," \
            "but got ${#POSITIONAL_ARGS_REF[@]}: '${POSITIONAL_ARGS_REF[*]}'."
    fi
}

cli::args::verify::self_test() (
    local -A SCOPE=()
    ARG_SCOPE='SCOPE'

    # declare metadata
    local ARG_META='MY_META'
    ARG_TYPE='cli_meta' \
        cli::core::variable::declare ${ARG_META}

    # load metadata
    cli::core::variable::read ${ARG_META} < <( 
        cli dsl sample ---load 
    )

    # cli dsl sample
    diff <(
        # sample command line
        local COMMAND_LINE='--id 42 -f banana -h --header Foo -- a0 a1'
        cli args tokenize -- ${COMMAND_LINE} \
            | cli args parse -- \
                <( cli::core::variable::write ${ARG_META}_ALIAS ) \
            | ${CLI_COMMAND[@]} --
    ) - <<-EOF || cli::assert
			first_named id
			positional a0
			positional a1
			named fruit banana
			named id 42
			named header Foo
			EOF
return

    meta() {
        echo 'type props map'
        echo 'regex props ^[0-9]$'
    }
    
    # supply list (e.g. '--props a=0 b=1')
    cli args tokenize -- --props a=0 b=1 \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named props' \
            'named props a=0' \
            'named props b=1'

    meta() {
        echo 'type name array'
        echo 'regex name ^[a-z]$'
    }

    # supply list (e.g. '--name a b')
    cli args tokenize -- --name a b \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named name' \
            'named name a' \
            'named name b'

    # supply list with regex mismatch (e.g. '--name 0')
    cli args tokenize -- --name a b 0 \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Unexpected value '0' for argument '--name' passed to command 'cli args initialize'." \
            "Expected a value that matches regex '^[a-z]$'."
                
    meta() {
        echo 'type name array'
        echo 'allow name a'
        echo 'allow name b'
    }

    # supply list with allow mismatch (e.g. '--name 0')
    cli args tokenize -- --name a b 0 \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Unexpected value '0' for argument '--name' passed to command 'cli args initialize'." \
            "Expected a value in the set { b a }."

    meta() {
        echo 'type name string'
        echo 'require name'
    }

    # fail to supply required named argument (e.g. no '--name')
    cli args tokenize \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Missing required argument '--name' in call to command '${CLI_COMMAND[@]}'."

    # empty string for required named argument (e.g. '--name ""')
    cli args tokenize -- --name \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Required argument '--name' passed to command 'cli args initialize' has empty value."

    # provide unknown named argument (e.g. '--bad')
    cli args tokenize -- --name foo --bad \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Unexpected unknown argument '--bad' passed to command '${CLI_COMMAND[@]}'."

    # provide required named argument (e.g. '--name bar')
    cli args tokenize -- --name foo \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named name' \
            'named name foo' 

    meta() {
        echo 'type value string'
        echo 'regex value ^[0-9]+$'
    }

    # fail regex (e.g. '--value 1a')
    cli args tokenize -- --value 1a \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Unexpected value '1a' for argument '--value' passed to command 'cli args initialize'." \
            "Expected a value that matches regex '^[0-9]+$'."

    # provide required named argument (e.g. '--value 42')
    cli args tokenize -- --value 42 \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named value' \
            'named value 42' 

    meta() {
        echo 'type color string'
        echo 'DEFAULT color black'
    }

    #  DEFAULT (e.g. '--color black')
    cli args tokenize \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named' \
            'named color black' 

    # override DEFAULT value (e.g. --color white)
    cli args tokenize -- --color white \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named color' \
            'named color white'

    # override DEFAULT value with alias (e.g. -c white)
    cli args tokenize -- -c white \
        | cli args parse -- <( echo 'c color' ) \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named color' \
            'named color white'

    meta() {
        echo 'type help boolean'
    }

    # DEFAULT boolean
    cli args tokenize \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named'

    # implicit boolean (e.g. '--help')
    cli args tokenize -- --help \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named help' \
            'named help'

    # bad allowed value (e.g. '--help bad')
    cli args tokenize -- --help bad \
        | cli args parse \
        | assert::fails "${CLI_COMMAND[@]} -- <( meta )" \
            "Unexpected value 'bad' for argument '--help'" \
            "passed to command 'cli args initialize'." \
            "Expected a value that matches regex '^true$|^false$|^$'."

    meta() {
        echo 'positional true'
    }

    # positional argument allowed
    cli args tokenize -- -- a0 a1 \
        | cli args parse \
        | ${CLI_COMMAND[@]} -- <( meta ) \
        | assert::pipe_records_eq \
            'first_named' \
            'positional a0' \
            'positional a1'
)
