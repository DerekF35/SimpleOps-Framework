ENV_FILE=$(dirname "$0")/env.sh

if [ -f ${ENV_FILE} ]
then
	source ${ENV_FILE}
fi

SCRIPT_LOCATION=${SCRIPT_LOCATION:-"$(dirname $0)"}
MENU_JOB_LOCATION=${MENU_JOB_LOCATION:-"${SCRIPT_LOCATION}"}
MENU_JOB_FILENAME=${MENU_JOB_FILENAME:-"menu_jobs.tab"}
LOG_LOCATION=${LOG_LOCATION:-"$(dirname "$0")/logs"}
REMOTE_SERVER_CONFIGS=${REMOTE_SERVER_CONFIGS:-"$(dirname $0)/remote_servers/"}
LOCAL_PRE_COMMAND=${LOCAL_PRE_COMMAND:-""}

MENU_JOB_FILE=${MENU_JOB_LOCATION}/${MENU_JOB_FILENAME}
LOG_DATE_FORMAT='+%Y%m%d_%H%M%S'
EXIT_CODE_FILE=$(mktemp)



source $(dirname "$0")/includes/automation_includes.sh
source $(dirname "$0")/includes/notification.sh

mkdir -p ${LOG_LOCATION}
