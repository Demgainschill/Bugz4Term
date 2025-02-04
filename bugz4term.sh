#!/bin/bash

# This script allows for creating 4 terminator windows that are loaded with the user specified commands. The command will be defaulted to creating 4 terminator windows each loaded with user specified commands in each terminator window ready to be executed when time is a concern in bug bounty or any specific methodology since you are able to have custom commands loaded.
usage(){
	cat <<EOF
	Usage: ./bugs4term.sh [options]
		-c : Run bugs4term from the bugs4term cofiguration file
EOF
}

loadRunConfig(){
	configFile="$1"
	$(xdotool key "ctrl+shift+t")
	$(xdotool type "$(sed -rn '1p' "$configFile")")
	$(xdotool keydown ctrl keydown shift key Down keyup shift keyup ctrl)
	$(xdotool type "$(sed -rn '2p' "$configFile")")
	sleep 1
	$(xdotool key "ctrl+shift+t")
	$(xdotool type "$(sed -rn '3p' "$configFile")")
	$(xdotool keydown ctrl keydown shift key Down keyup shift keyup ctrl)
	$(xdotool type "$(sed -rn '4p' "$configFile")")
}

while getopts ":c:" OPTS; do
	case "$OPTS" in
		c)
			bugs4termConfigFile=".bugs4term.conf"
			if [[ -f "$OPTARG" ]] && [[ "$OPTARG" =~ "$bugs4termConfigFile" ]] ; then
				echo "Running Commands from .config file.."
				loadRunConfig "$OPTARG"
				exit 1
			else
				echo "Is not .bugs4term.conf file"
				exit 1
			fi
			;;
		\?)
			echo "Invalid option"
			usage
			exit 1
			;;
		*)
			echo "No argument provided"
			usage
			exit 1
			;;
	esac
done

if [[ $# -lt 1 ]]; then
       usage
       exit 1
fi       

shift $((OPTIND-1))

if [[ -n $1 ]]; then
	echo "Too many arguments"
	usage
	exit 1
fi
