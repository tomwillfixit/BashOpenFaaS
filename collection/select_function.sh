#!/bin/bash

# Simple script to call a specific function

# functions stored in /tmp/functions and copied into docker image at build time

function usage()
{

echo "Requires function name and args :"
echo "Example : echo -n \"--function weather --argument Dublin\" | faas invoke collection"

}

# positional args
  args=()

  if [ "$1" = "" ];then
      usage
      exit 1
  fi

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
          -f | --function )   function="$2";     shift;;
          -a | --argument )   argument="$2";      shift;;
      esac
      shift # move to next kv pair
  done

if [ -z ${function} ];then
    usage
    exit 1
else
    if [ ! -f /tmp/functions/${function} ];then
        echo "Function does not exist : ${function}. Exiting"
        exit 1
    else
        echo "Running Function : ${function}"
        echo "Passing in Argument : ${argument}" 
    fi
fi

cd /tmp/functions

./${function} "${argument}"

exit $? 
