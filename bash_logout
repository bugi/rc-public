#!/bin/bash

if [ -z "$TMUX" ]
then # don't kill ssh-agent when tmux session goes away
	ssh-agent -k
fi

if [ -x /usr/games/fortune ]
then
	alias fortune="/usr/games/fortune"
elif [ -x /usr/local/bin/fortune ]
then
	alias fortune="/usr/local/bin/fortune"
else
	: alias fortune='telnet cookie.icce.rug.nl 4002'
	alias fortune='echo "fortune: Command not found."'
fi

clear

echo '--------------------------------------------------'
fortune
echo '--------------------------------------------------'

echo -n $(date) at $(hostname -f) >| "$HOME"/.lastlogout

junk=x
while [ -n "$junk" ]
do
	echo -n ">"
	read junk
	if [ -n "$junk" ]
	then
		echo "${junk}: Command not found."
	fi

done

echo 'bye ' $(id -un)
