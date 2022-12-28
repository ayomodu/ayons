#!/usr/bin/env bash

set -eou pipefail

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


error_msg="No Namespaces To List"

# namespace=$(echo $2 | tr [:upper:] [:lower:])

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
    if [ -z $ns ]
    then
        echo $error_msg 
        exit 1
    else
        kubectl get ns | cut -d " " -f 1 | cut -d $'\n' -f 2-
    fi
}

error(){
    local namespace
    namespace="$1"
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

switchnamespace(){
    local VAR
    local namespace
    namespace="$1"
    VAR=$(checkx)
    swns="kubectl config set-context --current --namespace=$namespace"
    if [ -z $VAR ]
    then
        error $namespace
    else
        $swns
        echo "Current Namespace $namespace"
    fi
}


creatns(){
    local VAR
    local namespace
    namespace="$1"
    VAR=$(checkx)
    create_namespace="kubectl create ns $namespace"
    if [ -z $VAR ]
    then
        $create_namespace
    else
        if [[ $VAR == $namespace ]]
        then
            echo "$namespace already exists!!!"
        else
            $create_namespace    
        fi
    fi
}


case $1 in
    -h|--help)
    usage ;;
    -v|--version)
    display_version ;;
    switch)
    shift; switchnamespace $1 ;;
    create)
    shift; creatns $1 ;;
    ls)
    shift; list_namespaces ;;
    *)
    echo "Unknown Command Argument: $*"
    usage
    ;;
esac
