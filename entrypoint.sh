#!/bin/sh

set -e

if [ -n "$SSH_PRIVATE_KEY" ]
then
  mkdir -p /root/.ssh
  echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
fi

if [ -n "$SSH_KNOWN_HOSTS" ]
then
  mkdir -p /root/.ssh
  echo "StrictHostKeyChecking yes" >> /etc/ssh/ssh_config
  echo "$SSH_KNOWN_HOSTS" > /root/.ssh/known_hosts
  chmod 600 /root/.ssh/known_hosts
else
  echo -e "\e[33m WARNING: StrictHostKeyChecking disabled \e[0m"
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
fi

mkdir -p ~/.ssh
cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true

chmod -R 777 "/git-sync.sh"
sh -c "/git-sync.sh $*"
