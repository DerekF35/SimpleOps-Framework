function run(){
	mkdir -p $(dirname "$0")/logs
	log=${LOG_LOCATION}/menu_$(date ${LOG_DATE_FORMAT} )_${1}.log
	echo "Log: $log" |& tee -a $log
	echo $(printf "\"%s\" " "${@}") |& tee -a $log
	echo "------------" |& tee -a $log
	run_cmd "${2}" "${3}" |& tee -a $log
    cat $log | less +G
}

function runScript(){
	mkdir -p $(dirname "$0")/logs
	log=${LOG_LOCATION}/cron_$(date ${LOG_DATE_FORMAT} )_${1}.log
	echo "Log: $log" |& tee -a $log
	echo $(printf "\"%s\" " "${@}") |& tee -a $log
	echo "------------" |& tee -a $log
	run_cmd "${2}" "${3}" |& tee -a $log
}

function run_cmd(){
	set +e
	if [ "${1}" == "local" ]
	then
		cd ${SCRIPT_LOCATION}
		eval "${2}"
		writeExitCode "$?"
	else
		source ${REMOTE_SERVER_CONFIGS}/${1}.sh
		${SSH_COMMAND} <<ENDSSH
		cd ${SCRIPT_LOCATION}
		echo "Beginning command run. (${2})..."
		echo ""
		${2}
		exit $?
ENDSSH
		writeExitCode "$?"
	fi
	set -e
}

function writeExitCode(){
	echo ${1} >| $EXIT_CODE_FILE
}

function readExitCode(){
	echo $(cat $EXIT_CODE_FILE)
}

