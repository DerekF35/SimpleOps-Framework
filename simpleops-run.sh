#!/bin/bash
source $(dirname "$(readlink -f "$0")")/includes/include.sh

function clean {
  rm -f $EXIT_CODE_FILE
}

trap clean EXIT

while getopts ":t:s:c:n:" opt; do
  case $opt in
    t)
      echo "-$opt was triggered, Parameter: $OPTARG" >&2
      JOBNAME=${OPTARG:-unknown}
      ;;
    s)
      echo "-$opt was triggered, Parameter: $OPTARG" >&2
      SERVER=$OPTARG
      ;;
    c)
      echo "-$opt was triggered, Parameter: $OPTARG" >&2
      COMMAND=$OPTARG
      ;;
    n)
      echo "-$opt was triggered, Parameter: $OPTARG" >&2
      NOTIFICATION=$OPTARG
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

arg_chk_pass=1
if [ -z ${JOBNAME+x} ]; then echo "JOBNAME is unset. Use -t <input>"; arg_chk_pass=0; fi
if [ -z ${SERVER+x} ]; then echo "SERVER is unset. Use -s <input>"; arg_chk_pass=0; fi
if [ -z ${COMMAND+x} ]; then echo "COMMAND is unset. Use -c <input>"; arg_chk_pass=0; fi
if [ -z ${NOTIFICATION+x} ]; then echo "NOTIFICATION is unset. Notifying on failure"; NOTIFICATION=failure; fi
if [ "$arg_chk_pass" != "1" ]; then exit 1; fi

runScript "$JOBNAME" "$SERVER" "$COMMAND"
scriptExitCode="$(readExitCode)"

my_log=${LOG_LOCATION}/$( readDataValue ${MY_DATA_FILE} LOG )
my_log_link=${WEB_LOCATION}/$( readDataValue ${MY_DATA_FILE} LOG )

if [ "${NOTIFICATION}" != "none" ] && [ "${scriptExitCode}" != "0" ]; then
  slackNotify ${JOBNAME} "$(getResultText $scriptExitCode )" ${my_log_link};
  exit 0
fi

case $NOTIFICATION in
	none) echo "No notifcation set";;
	all) slackNotify ${JOBNAME} "$( getResultText $scriptExitCode )" ${my_log_link};;
  grep=*) if [ "$( grep -P "${NOTIFICATION//grep=/}" ${my_log} | wc -l )" != "0" ]; then slackNotify ${JOBNAME} "NOTIFICATION" ${my_log_link} ; fi;;
esac

rm -f ${MY_DATA_FILE}
