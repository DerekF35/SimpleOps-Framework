# Slack Webhook Information
SLACK_WEBHOOK_ENABLED=1 # 1 or 0
WEBHOOK=
CHANNEL=
USERNAME=
EMOJI=

SCRIPT_LOCATION=$(dirname "$(readlink -f "$0")")

DEFAULT_JOB_FILE=$(dirname "$(readlink -f "$0")")/jobs.tab

LOG_BASE=$(dirname "$(readlink -f "$0")")
LOG_DIR=logs
WEB_SERVER=http:/localhost

REMOTE_SERVER_CONFIGS=$(dirname "$(readlink -f "$0")")/remote_servers/
