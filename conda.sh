#!/bin/bash

export SSB_CHANNEL_PUBLIC=http://ssb.stsci.edu/astroconda
export SSB_CHANNEL_DEV=http://ssb.stsci.edu/conda-dev


function ssb_emesg
{
    echo "ERROR: $@"
}


function ssb_entry_checkpoint
{
    if ! hash conda 2>/dev/null; then
        ssb_emesg "'conda' was not found in your PATH"
        return 1
    fi

    return 0
}

ssb_entry_checkpoint
retval=$?
if [[ $retval != 0 ]]; then
    return $retval
fi
unset -f ssb_entry_checkpoint


function ssb_usage
{
    echo "Usage: ssb {-i|-u} {-p|-d} [-an] [[package] ...]

General Arguments:
    --help          -h      This usage message
    --name [env]    -n      Update existing environment by name
    --public        -p      Use astroconda
    --dev           -d      Use conda-dev
    --all           -a      Update all packages (supersedes [package] requests)
    --yes           -y      Do not prompt (use with care)

Mode Arguments:
    --install       -i      Perform an installation
    --update        -u      Perform an update
    --create        -c      Create an environment

Positional Arguments:
package                 Name of package(s) to update

"
    return 0
}


function ssb
{
    local cmd="conda "
    local opts=""
    local is_public=0
    local is_dev=0
    local is_all=0
    local is_named=0
    local is_create=0
    local is_update=0
    local is_install=0

    if [[ $# < 1 ]]; then
        ssb_emesg "Not enough arguments"
        ssb_usage
        return 1
    fi

    while [[ $# > 0 ]]
    do
        key=$1

        case $key in
            --help|-h)
                ssb_usage
                return 0
                ;;

            --create|-c)
                is_create=1
                ;;

            --install|-i)
                is_install=1
                ;;

            --update|-u)
                is_update=1
                ;;

            --name|-n)
                opts+="--name $2 "
                is_named=1
                shift
                ;;

            --dev|-d)
                opts+="--override-channels -c $SSB_CHANNEL_DEV -c defaults "
                is_public=1
                ;;

            --public|-p)
                opts+="--override-channels -c $SSB_CHANNEL_PUBLIC -c defaults "
                is_dev=1
                ;;

            --all|-a)
                opts+="--all "
                is_all=1
                ;;

            --yes|-y)
                opts+="--yes "
                ;;
            *)
                opts+="$key "
                ;;
        esac

        shift
    done


    if [[ $is_public != 0 ]] && [[ $is_dev != 0 ]]; then
        ssb_emesg "--public and --dev are mutually exclusive options"
        ssb_usage
        return 1
    fi

    if [[ $is_public == 0 ]] && [[ $is_dev == 0 ]]; then
        ssb_emesg "--public or --dev must be specified"
        ssb_usage
        return 1
    fi

    if [[ $is_install == 0 ]] && [[ $is_update == 0 ]] && [[ $is_create == 0 ]]; then
        ssb_emesg "--install, --update, or --create is required"
        ssb_usage
        return 1
    fi

    if [[ $is_all != 0 ]]; then
        if [[ $is_public == 0 ]] && [[ $is_dev == 0 ]]; then
            ssb_emesg "--all cannot be used without --public or --dev"
            ssb_usage
            return 1
        fi

        if [[ $is_install != 0 ]]; then
            ssb_emesg "--all cannot be used with --install"
            ssb_usage
            return 1
        fi

        if [[ $is_create != 0 ]]; then
            ssb_emesg "--all cannot be used with --create"
            ssb_usage
            return 1
        fi
    fi

    if [[ $is_install != 0 ]]; then
        if [[ $is_update != 0 ]]; then
            ssb_emesg "--install and --update are mutually exclusive options"
            ssb_usage
            return 1
        fi

        if [[ $is_create != 0 ]]; then
            ssb_emesg "--install and --create are mutually exclusive options"
            ssb_usage
            return 1
        fi
    fi

    if [[ $is_update != 0 ]]; then
        if [[ $is_install != 0 ]]; then
            ssb_emesg "--update and --install are mutually exclusive options"
            ssb_usage
            return 1
        fi

        if [[ $is_create != 0 ]]; then
            ssb_emesg "--update and --create are mutually exclusive options"
            ssb_usage
            return 1
        fi
    fi

    if [[ $is_create != 0 ]]; then
        if [[ $is_install != 0 ]]; then
            ssb_emesg "--create and --install are mutually exclusive options"
            ssb_usage
            return 1
        fi

        if [[ $is_update != 0 ]]; then
            ssb_emesg "--create and --update are mutually exclusive options"
            ssb_usage
            return 1
        fi
    fi

    if [[ $is_install != 0 ]]; then
        opts="install $opts"
    fi

    if [[ $is_update != 0 ]]; then
        opts="update $opts"
    fi

    if [[ $is_create != 0 ]]; then
        opts="create $opts"
    fi

    if [[ -z $CONDA_PREFIX ]] && [[ $is_named == 0 ]]; then
        ssb_emesg "Refusing to corrupt base installation!"
        ssb_emesg "You are not in an active conda environment!"
        ssb_emesg "Use --name to interact with a specific environment!"
        ssb_usage
        return 1
    fi

    $cmd $opts
}

export -f ssb
