cli::bash::type::get_info () 
{ 
    local TYPE="${1-}";
    REPLY_CLI_BASH_TYPE_IS_INTEGER=false;
    REPLY_CLI_BASH_TYPE_IS_STRING=false;
    REPLY_CLI_BASH_TYPE_IS_SCALER=false;
    REPLY_CLI_BASH_TYPE_IS_ARRAY=false;
    REPLY_CLI_BASH_TYPE_IS_INTEGER_ARRAY=false;
    REPLY_CLI_BASH_TYPE_IS_MAP=false;
    REPLY_CLI_BASH_TYPE_IS_INTEGER_MAP=false;
    case "${TYPE}" in 
        '')
            REPLY=;
            REPLY_CLI_BASH_TYPE_IS_SCALER=true;
            REPLY_CLI_BASH_TYPE_IS_STRING=true
        ;;
        'i')
            REPLY=i;
            REPLY_CLI_BASH_TYPE_IS_SCALER=true;
            REPLY_CLI_BASH_TYPE_IS_INTEGER=true
        ;;
        'a')
            REPLY=a;
            REPLY_CLI_BASH_TYPE_IS_ARRAY=true
        ;;
        'A')
            REPLY=A;
            REPLY_CLI_BASH_TYPE_IS_MAP=true
        ;;
        'Ai')

        ;&
        'iA')
            REPLY=Ai;
            REPLY_CLI_BASH_TYPE_IS_MAP=true;
            REPLY_CLI_BASH_TYPE_IS_INTEGER_MAP=true
        ;;
        'ai')

        ;&
        'ia')
            REPLY=ai;
            REPLY_CLI_BASH_TYPE_IS_ARRAY=true;
            REPLY_CLI_BASH_TYPE_IS_INTEGER_ARRAY=true
        ;;
        *)
            cli::assert "Unexpected type '$@'."
        ;;
    esac
}
