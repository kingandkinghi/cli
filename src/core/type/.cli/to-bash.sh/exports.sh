cli::core::type::to_bash () 
{ 
    local TYPE="${1-}";
    case "${TYPE}" in 
        'string')
            REPLY=
        ;;
        'integer')
            REPLY=i
        ;;
        'array')
            REPLY=a
        ;;
        'map')
            REPLY=A
        ;;
        'map_of')
            REPLY=A
        ;;
        'boolean')
            REPLY=
        ;;
        *)
            return 1
        ;;
    esac
}
