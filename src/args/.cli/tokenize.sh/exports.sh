cli::source cli core variable declare
cli::source cli core variable unset
cli::source cli stderr test
cli::args::tokenize () 
{ 
    : ${ARG_SCOPE?'Missing scope.'};
    local TOKENS='REPLY_CLI_ARGS_TOKENS';
    cli::core::variable::unset "${TOKENS}";
    cli::core::variable::declare cli_tokens "${TOKENS}";
    local -n TOKEN_REF="${TOKENS}_ID";
    local -n IDENTIFIER_REF="${TOKENS}_IDENTIFIER";
    local NAME_REGEX='[a-z][a-z0-9-]*';
    local DASH_REGEX="^-[^-].*$";
    local DASH_FLAGS_REGEX="^-([a-z]+)$";
    local DASH_DASH_REGEX="^--[^-].*$";
    local DASH_DASH_OPTION_REGEX="^--(${NAME_REGEX})$";
    local DASH_DASH_DASH_REGEX="^---[^-].*$";
    local DASH_DASH_DASH_OPTION_REGEX="^---(${NAME_REGEX})$";
    local DASH_DASH='--';
    function yield () 
    { 
        TOKEN_REF+=($1);
        IDENTIFIER_REF+=("${2-}")
    };
    while (( $# > 0 )); do
        if [[ "$1" == ${DASH_DASH} ]]; then
            yield ${CLI_ARG_TOKEN_END_OPTIONS};
            shift;
            while (( $# > 0 )); do
                yield ${CLI_ARG_TOKEN_VALUE} "$1";
                shift;
            done;
            break;
        else
            if [[ "$1" == ---* ]]; then
                if [[ ! "$1" =~ ^---([a-z][a-z0-9-]*)$ ]]; then
                    cli::stderr::fail "Unexpected option \"$1\"" "does not match regex ${DASH_DASH_DASH_OPTION_REGEX}" "passed to command \"${CLI_COMMAND[@]}\".";
                fi;
                yield ${CLI_ARG_TOKEN_DASH_DASH_DASH} "${1:3}";
            else
                if [[ "$1" == --* ]]; then
                    if [[ ! "$1" =~ ^--([a-z][a-z0-9-]*)$ ]]; then
                        cli::stderr::fail "Unexpected option \"$1\"" "does not match regex ${DASH_DASH_OPTION_REGEX}" "passed to command \"${CLI_COMMAND[@]}\".";
                    fi;
                    yield ${CLI_ARG_TOKEN_DASH_DASH} "${1:2}";
                else
                    if [[ "$1" == -* ]]; then
                        if [[ ! "$1" =~ ^-([a-z][a-z0-9-]*)$ ]]; then
                            cli::stderr::fail "Unexpected option \"$1\"" "does not match regex ${DASH_FLAGS_REGEX}" "passed to command \"${CLI_COMMAND[@]}\".";
                        fi;
                        yield ${CLI_ARG_TOKEN_DASH} "${1:1}";
                    else
                        yield ${CLI_ARG_TOKEN_VALUE} "$1";
                    fi;
                fi;
            fi;
        fi;
        shift;
    done;
    yield ${CLI_ARG_TOKEN_EOF};
    REPLY=${TOKENS}
}
