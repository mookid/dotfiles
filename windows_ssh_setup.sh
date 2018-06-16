#!/bin/sh

# source:
# https://help.github.com/articles/working-with-ssh-key-passphrases/

ENV=~/.ssh/agent.env

agent_load_env () { test -f "$ENV" && . "$ENV" >| /dev/null ; }

agent_start () {
        (umask 077; ssh-agent >| "$ENV")
        . "$ENV" >| /dev/null ; }

agent_load_env

AGENT_RUN_STATE=$(ssh-add -l >| /dev/null 2>&1; echo $?)
# 0 = agent running with key
# 1 = agent without key
# 2 = agent not running

if [ ! "$SSH_AUTH_SOCK" ] || [ $AGENT_RUN_STATE = 2 ]
then
        agent_start
        ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $AGENT_RUN_STATE = 1 ]
then
        ssh-add
fi

unset ENV
