ENV_FILE=$(dirname "$(readlink -f "$0")")/env.sh

if [ -f ${ENV_FILE} ]
then
	source ${ENV_FILE}
fi

SCRIPT_LOCATION=${SCRIPT_LOCATION:-"$(dirname "$(readlink -f "$0")")"}
MENU_JOB_LOCATION=${MENU_JOB_LOCATION:-"${SCRIPT_LOCATION}"}
MENU_JOB_FILENAME=${MENU_JOB_FILENAME:-"menu_jobs.tab"}
LOG_LOCATION=${LOG_LOCATION:-"$(dirname "$(readlink -f "$0")")/logs"}
REMOTE_SERVER_CONFIGS=${REMOTE_SERVER_CONFIGS:-"$(dirname "$(readlink -f "$0")")/remote_servers/"}
LOCAL_PRE_COMMAND=${LOCAL_PRE_COMMAND:-""}

MENU_JOB_FILE=${MENU_JOB_LOCATION}/${MENU_JOB_FILENAME}
LOG_DATE_FORMAT='+%Y%m%d_%H%M%S'
EXIT_CODE_FILE=$(mktemp)

WEB_LOCATION="${WEB_SERVER}/${LOG_DIR}"
LOG_LOCATION=${LOG_BASE}/${LOG_DIR}

source $(dirname "$(readlink -f "$0")")/includes/automation_includes.sh
source $(dirname "$(readlink -f "$0")")/includes/notification.sh
source $(dirname "$(readlink -f "$0")")/includes/data_file.sh

mkdir -p ${LOG_LOCATION}
