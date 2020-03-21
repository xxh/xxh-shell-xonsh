#!/bin/bash

while getopts f:c:C:v:e:b: option
do
case "${option}"
in
f) EXECUTE_FILE=${OPTARG};;
c) EXECUTE_COMMAND=${OPTARG};;
C) EXECUTE_COMMAND_B64=${OPTARG};;
v) VERBOSE=${OPTARG};;
e) ENV+=("$OPTARG");;
b) EBASH+=("$OPTARG");;
esac
done

if [[ $VERBOSE != '' ]]; then
  export XXH_VERBOSE=$VERBOSE
fi

for env in "${ENV[@]}"; do
  name="$( cut -d '=' -f 1 <<< "$env" )";
  val="$( cut -d '=' -f 2- <<< "$env" )";
  val=`echo $val | base64 -d`

  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Environment variable "$env": name=$name, value=$val
  fi

  export $name="$val"
done

for eb in "${EBASH[@]}"; do
  bash_command=`echo $eb | base64 -d`

  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Entrypoint bash execute: $bash_command
  fi
  eval $bash_command
done

if [[ $EXECUTE_COMMAND ]]; then
  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Execute command: $EXECUTE_COMMAND
  fi

  EXECUTE_COMMAND=(-c "${EXECUTE_COMMAND}")
fi

if [[ $EXECUTE_COMMAND_B64 ]]; then
  EXECUTE_COMMAND=`echo $EXECUTE_COMMAND_B64 | base64 -d`
  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Execute command base64: $EXECUTE_COMMAND_B64
    echo Execute command: $EXECUTE_COMMAND
  fi

  EXECUTE_COMMAND=(-c "${EXECUTE_COMMAND}")
fi

EXECUTE_FILE=`[ $EXECUTE_FILE ] && echo -n "-- $EXECUTE_FILE" || echo -n ""`

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $CURRENT_DIR

# Check FUSE support
check_result=`./xonsh --no-script-cache -i --rc xonshrc.xsh -- $CURRENT_DIR/../../../package/settings.py 2>&1`
if [[ ! -f .entrypoint-check-done ]]; then
  if [[ $check_result == *"FUSE"* ]]; then
    #echo "Extract AppImage" 1>&2  # TODO: verbose mode
    ./xonsh --appimage-extract > /dev/null # TODO: verbose mode
    mv squashfs-root xonsh-squashfs
    mv xonsh xonsh-disabled
    ln -s ./xonsh-squashfs/usr/bin/python3 xonsh
  fi
  echo $check_result > .entrypoint-check-done
fi

export XXH_HOME=`realpath $CURRENT_DIR/../../../..`
export XONSH_HISTORY_FILE=$XXH_HOME/.xonsh_history

./xonsh --no-script-cache -i --rc xonshrc.xsh $EXECUTE_FILE "${EXECUTE_COMMAND[@]}"
