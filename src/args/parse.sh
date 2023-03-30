#!/usr/bin/env CLI_TOOL=cli bash-cli-part
CLI_IMPORT=(
    "cli core variable declare"
    "cli core variable put"
    "cli core variable read"
    "cli core variable unset"
    "cli core variable write"
    "cli args tokenize"
)

cli::args::parse::help() {
    cat << EOF
Command
    ${CLI_COMMAND[@]}
    
Summary
    Parse a command line.

Description
    Given positional and named arguments return JSON blob. Use -- before arguments
    to distinguish arguments to the parse command itself (e.g. like '-h') vs those
    to be parsed. Read pair records form stdin for aliases (e.g. 'h help').
EOF
    cat << EOF

Examples
    # Parse '--option value -h --param/key value -- a0 a1'
    Parse '--option value -h-- a0 a1'
        cli args parse -- --option value -h -- a0 a1 \\
            < <(cli sample simple ---load) | sort

    Produces:
        named help 0
        named option 0 value
        positional 0 a0
        positional 1 a1
EOF
}

cli::args::parse::main() {
    local -A SCOPE=()
    ARG_SCOPE='SCOPE'

    ARG_TYPE='cli_meta' cli::core::variable::declare MY_META
    cli::core::variable::read MY_META
    cli::args::tokenize "$@"
    cli::args::parse MY_META_ALIAS "${REPLY}"
    cli::core::variable::write "${REPLY}"
}

cli::args::parse() {
    : ${ARG_SCOPE?'Missing scope.'}

    local ALIAS="$1"
    shift

    local TOKENS="$1"
    shift

    local -n ALIAS_REF="${ALIAS}"
    local -n TOKEN_REF="${TOKENS}_ID"
    local -n IDENTIFIER_REF="${TOKENS}_IDENTIFIER"
    
    local ARGS='REPLY_CLI_ARGS_PARSE'
    cli::core::variable::unset "${ARGS}"
    ARG_TYPE='cli_args' \
        cli::core::variable::declare "${ARGS}"

    local -i current=0
    local token_name=
    local identifier=
    local token=

    read_token() {
        token=${TOKEN_REF[$current]}
        token_name=${CLI_ARG_TOKEN[$token]}
        identifier=${IDENTIFIER_REF[$current]}

        # if (( $# > 0 )); then
        #     assert_token_is "$@"
        # fi
        current=$(( current + 1 ))
    }

    START() {
        read_token

        while (( token != CLI_ARG_TOKEN_EOF )); do

            if (( token == CLI_ARG_TOKEN_DASH )); then
                FLAG
            elif (( token == CLI_ARG_TOKEN_DASH_DASH )); then
                OPTION
            elif (( token == CLI_ARG_TOKEN_DASH_DASH_DASH )); then
                INTERNAL_OPTION
            elif (( token == CLI_ARG_TOKEN_END_OPTIONS )); then
                POSITIONAL
            else
                cli::stderr::fail "Unexpected arg '${identifier}' (token type ${token_name})" \
                    "encountered while parsing cli."
            fi
        done
    }

    POSITIONAL() {
        read_token

        while (( token != CLI_ARG_TOKEN_EOF )); do
            # assert_token_is TOKEN_VALUE
            cli::core::variable::put ${ARGS} positional "${identifier}"
            read_token
        done
    }

    FLAG() {

        # trap for unknown arguments
        local alias="${ALIAS_REF[$identifier]-}"
        if [[ -z "${alias}" ]]; then
            cli::stderr::fail "Unexpected unknown alias \"-${identifier}\"" \
                "passed as argument ? to command '${CLI_COMMAND[@]}'."
        fi

        identifier="${alias}"
        OPTION
    }

    INTERNAL_OPTION() {
        local option="${identifier}"
        read_token

        # list of values (typically only one but could be array or properties)
        while (( token == CLI_ARG_TOKEN_VALUE )); do
            read_token 
        done
    }

    OPTION() {
        local option="${identifier}"
        read_token

        # flags
        if (( token != CLI_ARG_TOKEN_VALUE )); then
            cli::core::variable::put ${ARGS} named "${option}" ''
            return
        fi

        # list of values (typically only one but could be array or properties)
        while (( token == CLI_ARG_TOKEN_VALUE )); do
            cli::core::variable::put ${ARGS} named "${option}" "${identifier}"
            read_token 
        done
    }

    START

    REPLY="${ARGS}"
}

cli::args::parse::self_test() {
    diff <(
        cli args parse --myarr a c b --myprops a=0 c=2 b=1 </dev/null \
            | sort
    ) - <<-EOF
		named myarr 0 a
		named myarr 1 c
		named myarr 2 b
		named myprops 0 a=0
		named myprops 1 c=2
		named myprops 2 b=1
		EOF

    diff <(
        cli args parse -- -h -t --test opt --test key=value -- a0 a2 a1 \
            <<< $'alias h help\nalias t test\n'  \
            | sort
    ) - <<-EOF
		named help 0
		named test 0
		named test 1 opt
		named test 2 key=value
		positional 0 a0
		positional 1 a2
		positional 2 a1
		EOF
}
