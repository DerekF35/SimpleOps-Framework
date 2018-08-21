function getResultText(){
	if [ "${1}" == "0" ]
	then
		echo "Success"
	else
		echo "FAILED"
	fi
}

function slackNotify(){
	MSG=$1

	PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$MSG\", \"icon_emoji\": \"$EMOJI\"}"

	curl -X POST --data-urlencode "$PAYLOAD" "$WEBHOOK"
}
