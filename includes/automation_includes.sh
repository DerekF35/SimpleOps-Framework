function run(){
	log=${LOG_LOCATION}/menu_$(date ${LOG_DATE_FORMAT} )_${1}.log
	echo "Log: $log" |& tee -a $log
	echo $(printf "\"%s\" " "${@}") |& tee -a $log
	echo "------------" |& tee -a $log
	run_cmd "${2}" "${3}" |& tee -a $log
    cat $log | less +G
}

function runScript(){
	log=${LOG_LOCATION}/cron_$(date ${LOG_DATE_FORMAT} )_${1}.log
	echo "Log: $log" |& tee -a $log
	echo $(printf "\"%s\" " "${@}") |& tee -a $log
	echo "------------" |& tee -a $log
	run_cmd "${2}" "${3}" |& tee -a $log
}

function run_remote_script(){
	echo "Running remote script.."
	run_cmd "${1}" "${2}" "X"
}

function run_cmd(){
	set +e
	if [ "${1}" == "local" ]
	then
		cd ${SCRIPT_LOCATION}
		${LOCAL_PRE_COMMAND}
		echo "Beginning command run. (${2})..."
		eval ${2}
		writeExitCode "$?"
	else
		echo
		echo "################################"
		echo " Server: ${1}"
		echo " Server: ${2}"
		echo "################################"
		echo
		source ${REMOTE_SERVER_CONFIGS}/${1}.sh
		${SSH_COMMAND} <<ENDSSH
		cd ${SCRIPT_LOCATION}
		${PRE_COMMAND}
		echo
		echo "Beginning command run...."
		echo
		${2}
		export myExitCode=\${?}
		echo "### Exit Code: \$myExitCode"
		echo
		exit \$myExitCode
ENDSSH
		myExitCode="${?}"
		if [ "${3}" == "X" ]
		then
			if [ "${myExitCode}" != "0" ]
			then
				exit ${myExitCode}
			fi
		else
			writeExitCode "$myExitCode"
		fi
	fi
	set -e
}

function writeExitCode(){
	echo ${1} >| $EXIT_CODE_FILE
}

function readExitCode(){
	echo $(cat $EXIT_CODE_FILE)
}

function getEnvConfig(){
	cat ${REMOTE_SERVER_CONFIGS}/${1}.sh | sed -n -e "s/${2}=\(.*\)/\1/p"
}