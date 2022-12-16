#!/usr/bin/env bash

PROG="ayons"
PROG_VERSION="0.0.1"

USAGE="
Usage:
  $PROG create <namespace>
  $PROG switch <namespace>
  $PROG ls
  $PROG --help
  $PROG --version


Commands:
  create    Creates a new Kubernetes namespace in current cluster context.
  switch    Changes Kubernetes namespace current cluster context to <namespace>
  ls        Lists all namespaces in current cluster context

Options:
  -v, --version          Print the version of this tool.
  -h, --help             Print this help message.


For more details see also:
    https://www.github.com/ayomodu/ayons
"


error_list="No Namespaces To List, Create A Namespace Using: $ 'ayons create {namespace}'"

namespace=$(echo $1 | tr [:upper:] [:lower:])

ns=( $(kubectl get ns | cut -d " " -f 1 | cut -d $'\n' -f 2-) )


usage(){
    echo -e "$USAGE"
    exit 1
}

display_version(){
    echo -e "$PROG v$PROG_VERSION"
    exit 0
}

list_namespaces(){
    if [ -n $ns ]
    then
        echo $error_list | tr ":" "\n"
        exit 1
    else
        kubectl get ns
    fi
}

error(){
    echo "${namespace} namespace not found"
    exit 1
}

checkx(){
    for x in ${!ns[@]}
    do
        if [[ ${ns[x]} != $namespace ]]
        then
            :
        else
            echo ${ns[x]}
        fi

    done
}

VAR=$(checkx)


    # if [ -z $VAR ]
    # then
    #     error
    # else
    #     kubectl get pods -n $namespace
    # fi

case $1 in
    -h|--help)
    usage
    ;;
    -v|--version)
    display_version
    ;;
    ls)
    list_namespaces
    ;;
    *)
    echo "Unknown Command: $*"
    usage
    ;;
esac

