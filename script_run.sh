#!/bin/bash
source $(dirname "$0")/includes/include.sh

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
if [ -z ${NOTIFICATION+x} ]; then echo "NOTIFICATION is unset. Use -n [none|all|failure]"; arg_chk_pass=0; fi
if [ "$arg_chk_pass" != "1" ]; then exit 1; fi

runScript "$JOBNAME" "$SERVER" "$COMMAND"
scriptExitCode="$(readExitCode)"

case $NOTIFICATION in
	none) echo "No notifcation set";;
	all) slackNotify "${JOBNAME}: $(getResultText $scriptExitCode)";;
	failure) if [ "${1}" == "1" ]; then slackNotify "${JOBNAME}: $(getResultText $scriptExitCode)"; fi;;
esac
