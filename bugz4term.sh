#!/bin/bash

# This script allows for creating 4 terminator windows that are loaded with the user specified commands. The command will be defaulted to creating 4 terminator windows each loaded with user specified commands in each terminator window ready to be executed when time is a concern in bug bounty or any specific methodology since you are able to have custom commands loaded.

b=$(tput setaf 4)
r=$(tput setaf 1)
g=$(tput setaf 10)
y=$(tput setaf 3)
reset=$(tput sgr0)
c=$(tput setaf 14)
o=$(tput setaf 208) 


domain=""

usage(){
	cat <<EOF
${b}  _                     _  _   _                       ${reset}
${b} | |__  _   _  __ _ ___| || | | |_ ___ _ __ _ __ ___   ${reset}
${b} | '_ \| | | |/ _' |_  / || |_| __/ _ \ '__| '_ ' _ \  ${reset}
${b} | |_) | |_| | (_| |/ /|__   _| ||  __/ |  | | | | | | ${reset}
${b} |_.__/ \__,_|\__, /___|  |_|  \__\___|_|  |_| |_| |_| ${reset}
${b}              |___/                                    ${reset}

	${y}Usage${reset}: ${b}./bugz4term.sh${reset} ${y}-c${reset} .bugs4term.conf
	     ${y}-c${reset} .bugs4term.conf :${r} Run from .bugs4term.conf config file ${reset}
	     ${y}-h${reset}                 :${r} Help section ${reset}

	Example:
		Each line in the config file represents the commands to display on each tab of the terminator
		${g}./bugz4term.sh${reset} ${y}-c${reset} .bugs4term.conf
		First ${b}2${reset} lines/commands in ${y}tab 1${reset} in each terminator ${b}horizontal pane${reset}
		Second ${b}2${reset} lines/commands in ${y}tab 2${reset} in each terminator ${b}horizontal pane${reset}
EOF
}

loadRunConfig(){
	configFile="$1"
	$(xdotool key "ctrl+shift+t")
	$(xdotool type "$(sed -rn '1p' "$configFile")")
	$(xdotool keydown ctrl keydown shift key Down keyup shift keyup ctrl)
	sleep 0.5
	$(xdotool type "$(sed -rn '2p' "$configFile")")
	sleep 1
	$(xdotool key "ctrl+shift+t")
	$(xdotool type "$(sed -rn '3p' "$configFile")")
	$(xdotool keydown ctrl keydown shift key Down keyup shift keyup ctrl)
	sleep 0.5
	$(xdotool type "$(sed -rn '4p' "$configFile")")
}

while getopts ":c:hd:" OPTS; do
	case "$OPTS" in
		d)
			testDomain="${OPTARG}"
			grep -Eiwq "^(https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" <<< "$testDomain"
			if [[ $? -eq 0 ]]; then
				if [[ -n "$bugs4termConfigFile" ]] && [[ -f "$bugs4termConfigFile" ]]; then
					echo "file exists"
				else
					echo "Mention -c [config] flag as well. Exiting."
					exit 1
				fi
			else
				echo "Not a domain"
				exit 1
			fi
			;;
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

		h)
			usage
			exit 1
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
