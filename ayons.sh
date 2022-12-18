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


error_msg="No Namespaces To List"

namespace=$(echo $2 | tr [:upper:] [:lower:])

ns=( $(kubectl get ns | cut -d " " -f 1 | cut -d $'\n' -f 2-) )

# kubeoff="Unable to connect to the server: dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it."

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
    VAR=$(checkx)
    swns="kubectl config set-context --current --namespace=$namespace"
    if [ -z $VAR ]
    then
        error
    else
        $swns
    fi
}
case $1 in
    -h|--help)
    usage
    ;;
    -v|--version)
    display_version
    ;;
    switch)
    switchnamespace
    ;;
    ls)
    list_namespaces
    ;;
    *)
    echo "Unknown Command Argument: $*"
    usage
    ;;
esac

