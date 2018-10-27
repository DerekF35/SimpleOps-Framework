#!/bin/bash
set -e

source $(dirname "$0")/includes/include.sh

INPUT=$(mktemp)
OUTPUT=$(mktemp)

MENU_TMP=$(mktemp)
ACTION_TMP=$(mktemp)
MENUJOBCONFIG_TMP=$(mktemp)

JOB_CONFIG_FILE=${DEFAULT_JOB_FILE}
FUNC_COL=0
DESC_COL=1
ENV_COL=2
COMMAND_COL=3

while getopts ":c:" opt; do
  case $opt in
    c)
      echo "-$opt was triggered, Parameter: $OPTARG" >&2
      JOB_CONFIG_FILE=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# make a copy of the job file so it doesn't change while program is running
cp ${MENU_JOB_FILE} ${MENUJOBCONFIG_TMP}

trap "rm $OUTPUT; rm $INPUT; rm $MENU_TMP; $MY_DATA_FILE; exit" SIGHUP SIGINT SIGTERM

function pause(){
	read -p "Press any key to continue..."
}

cat >| $MENU_TMP <<- DIA
dialog --clear  --help-button --backtitle "FrankOps Deploy Menu"
		--title "SELECT SCRIPT TO RUN"
		--menu "You can use the UP/DOWN arrow keys, the first \n
		letter of the choice as a hot key, or the \n
		number keys 1-9 to choose an option.\n
		Choose the TASK" 40 50 30
		Exit "Exit to the shell"
DIA

while IFS=$'\t' read -r -a myArray
do
	echo " ${myArray[${FUNC_COL}]} \"${myArray[${DESC_COL}]}\"" >> $MENU_TMP
done < ${MENUJOBCONFIG_TMP}

menu_cmd="$(cat "$MENU_TMP")"

while true
do
	### display main menu ###
	eval $menu_cmd 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	if [ "${menuitem}" == "Exit" ]; then
		echo "Bye"
		break
	fi

	while IFS=$'\t' read -r -a myArray
	do
	 	if [ "${myArray[FUNC_COL]}" == "${menuitem}" ]
	 	then
			clear
	 		run ${myArray[$FUNC_COL]} ${myArray[$ENV_COL]} "${myArray[$COMMAND_COL]}"
	 	fi
	done < ${MENUJOBCONFIG_TMP}
done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
[ -f $MENU_TMP ] && rm $MENU_TMP
clear
