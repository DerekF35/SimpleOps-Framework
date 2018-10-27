function getResultText(){
	if [ "${1}" == "0" ]
	then
		echo "Success"
	else
		echo "FAILED"
	fi
}

function getResultColor(){
	if [ "${1}" == "Success" ]
	then
		echo "#008000"
	fi

	if [ "${1}" == "FAILED" ]
	then
		echo "#FF0000"
	fi
}

function slackNotify(){
	JOB=$1
	STATUS=$2
	LOG=$3
	MSG=$4

	PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"attachments\": [{\"fallback\":\"${JOB}: ${STATUS}\",\"color\":\"$(getResultColor ${STATUS})\",\"fields\": [{\"title\":\"Job\",\"value\":\"${JOB}\",\"short\":true},{\"title\":\"Result\",\"value\":\"${STATUS}\",\"short\":true},{\"title\":\"Log\",\"value\":\"${LOG}\"}]}], \"icon_emoji\": \"$EMOJI\"}"

	echo "Sending ${PAYLOAD} to ${WEBHOOK}"

	curl -X POST --data-urlencode "$PAYLOAD" "$WEBHOOK"
}
