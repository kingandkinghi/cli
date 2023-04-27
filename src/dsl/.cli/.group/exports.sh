declare -rg CLI_DSL_ARG_ALIAS_GLOB="-@([a-zA-Z0-9_-])"
declare -rg CLI_DSL_ARG_CHAR_GLOB="[a-zA-Z0-9_-]"
declare -rg CLI_DSL_ARG_NAME_GLOB="--@([a-zA-Z0-9_-])+([a-zA-Z0-9_-])"
declare -rg CLI_DSL_LITERAL_ALLOWED="Allowed"
declare -rg CLI_DSL_LITERAL_COLON=":"
declare -rg CLI_DSL_LITERAL_DASHDASH="--"
declare -rg CLI_DSL_LITERAL_DEFAULT="Default:"
declare -rg CLI_DSL_LITERAL_FLAG="[Flag]"
declare -rg CLI_DSL_LITERAL_LIST="[List]"
declare -rg CLI_DSL_LITERAL_PROPERTIES="[Properties]"
declare -rg CLI_DSL_LITERAL_REGEX="Regex:"
declare -rg CLI_DSL_LITERAL_REQUIRED="[Required]"
declare -rg CLI_DSL_LITERAL_TAB="    "
declare -rg CLI_DSL_LITERAL_VALUES="values:"
declare -arg CLI_DSL_PRODUCTION=([0]="NAME" [1]="ALIAS" [2]="DEFAULT" [3]="REGEX" [4]="REQUIRED" [5]="FLAG" [6]="TYPE" [7]="ALLOWED" [8]="ALLOWED_VALUE" [9]="ALLOWED_END" [10]="ERROR" [11]="ANYARGS" [12]="ARGUMENTS")
declare -rg CLI_DSL_PRODUCTION_ALIAS="1"
declare -rg CLI_DSL_PRODUCTION_ALLOWED="7"
declare -rg CLI_DSL_PRODUCTION_ALLOWED_END="9"
declare -rg CLI_DSL_PRODUCTION_ALLOWED_VALUE="8"
declare -rg CLI_DSL_PRODUCTION_ANYARGS="11"
declare -rg CLI_DSL_PRODUCTION_ARGUMENTS="12"
declare -rg CLI_DSL_PRODUCTION_DEFAULT="2"
declare -rg CLI_DSL_PRODUCTION_ERROR="10"
declare -rg CLI_DSL_PRODUCTION_FLAG="5"
declare -rg CLI_DSL_PRODUCTION_NAME="0"
declare -rg CLI_DSL_PRODUCTION_REGEX="3"
declare -rg CLI_DSL_PRODUCTION_REQUIRED="4"
declare -rg CLI_DSL_PRODUCTION_TYPE="6"
declare -arg CLI_DSL_TOKEN=([0]="DEFAULT" [1]="FLAG" [2]="LIST" [3]="PROPERTIES" [4]="ALLOWED_VALUES" [5]="VALUE_COMMA" [6]="VALUE_PERIOD" [7]="IDENTIFIER" [8]="NAME" [9]="ALIAS" [10]="COLON" [11]="REGEX" [12]="REQUIRED" [13]="EOF" [14]="ERROR" [15]="DASHDASH" [16]="ARGUMENTS")
declare -rg CLI_DSL_TOKEN_ALIAS="9"
declare -rg CLI_DSL_TOKEN_ALLOWED_VALUES="4"
declare -rg CLI_DSL_TOKEN_ARGUMENTS="16"
declare -rg CLI_DSL_TOKEN_COLON="10"
declare -rg CLI_DSL_TOKEN_DASHDASH="15"
declare -rg CLI_DSL_TOKEN_DEFAULT="0"
declare -rg CLI_DSL_TOKEN_EOF="13"
declare -rg CLI_DSL_TOKEN_ERROR="14"
declare -rg CLI_DSL_TOKEN_FLAG="1"
declare -rg CLI_DSL_TOKEN_IDENTIFIER="7"
declare -rg CLI_DSL_TOKEN_LIST="2"
declare -rg CLI_DSL_TOKEN_NAME="8"
declare -rg CLI_DSL_TOKEN_PROPERTIES="3"
declare -rg CLI_DSL_TOKEN_REGEX="11"
declare -rg CLI_DSL_TOKEN_REQUIRED="12"
declare -rg CLI_DSL_TOKEN_VALUE_COMMA="5"
declare -rg CLI_DSL_TOKEN_VALUE_PERIOD="6"
cli::dsl::help () 
{ 
    cat <<EOF
Command
    ${CLI_COMMAND[@]}
EOF

}
cli::dsl::main () 
{ 
    readonly CLI_DSL_ARG_CHAR_GLOB="[a-zA-Z0-9_-]";
    readonly CLI_DSL_ARG_ALIAS_GLOB="-@(${CLI_DSL_ARG_CHAR_GLOB})";
    readonly CLI_DSL_ARG_NAME_GLOB="--@(${CLI_DSL_ARG_CHAR_GLOB})+(${CLI_DSL_ARG_CHAR_GLOB})";
    readonly CLI_DSL_LITERAL_TAB='    ';
    readonly CLI_DSL_LITERAL_COLON=':';
    readonly CLI_DSL_LITERAL_REGEX='Regex:';
    readonly CLI_DSL_LITERAL_DEFAULT='Default:';
    readonly CLI_DSL_LITERAL_ALLOWED='Allowed';
    readonly CLI_DSL_LITERAL_VALUES='values:';
    readonly CLI_DSL_LITERAL_REQUIRED='[Required]';
    readonly CLI_DSL_LITERAL_FLAG='[Flag]';
    readonly CLI_DSL_LITERAL_LIST='[List]';
    readonly CLI_DSL_LITERAL_PROPERTIES='[Properties]';
    readonly CLI_DSL_LITERAL_DASHDASH='--';
    cli::bash::variable::declare_enum CLI_DSL_TOKEN 'DEFAULT' 'FLAG' 'LIST' 'PROPERTIES' 'ALLOWED_VALUES' 'VALUE_COMMA' 'VALUE_PERIOD' 'IDENTIFIER' 'NAME' 'ALIAS' 'COLON' 'REGEX' 'REQUIRED' 'EOF' 'ERROR' 'DASHDASH' 'ARGUMENTS';
    cli::bash::variable::declare_enum CLI_DSL_PRODUCTION 'NAME' 'ALIAS' 'DEFAULT' 'REGEX' 'REQUIRED' 'FLAG' 'TYPE' 'ALLOWED' 'ALLOWED_VALUE' 'ALLOWED_END' 'ERROR' 'ANYARGS' 'ARGUMENTS';
    cli::export cli dsl
}
cli::dsl::self_test () 
{ 
    ( cli sample simple --self-test );
    ( cli sample kitchen-sink --self-test );
    ( cli dsl tokenize --self-test );
    ( cli dsl parse --self-test );
    ( cli dsl meta --self-test );
    ( echo cli dsl load --self-test )
}
