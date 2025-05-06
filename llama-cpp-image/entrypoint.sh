#!/usr/bin/env bash

if [ -z ${HOME} ]
then
  export HOME=/home/llama-user
fi

# Create Home directory
if [ ! -d "${HOME}" ]
then
  mkdir -p "${HOME}"
fi

# Create User ID
if ! whoami &> /dev/null
then
  if [ -w /etc/passwd ] && [ -w /etc/group ]
  then
    echo "${USER_NAME:-llama-user}:x:$(id -u):0:${USER_NAME:-llama-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-llama-user}:x:$(id -u):" >> /etc/group
  fi
fi

if [ ! -f ${MODEL_STORE}/${MODEL} ]
then
  wget -O ${MODEL_STORE}/${MODEL} ${MODEL_URL}
fi

source /opt/intel/oneapi/setvars.sh

exec "$@"
