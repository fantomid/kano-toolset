# logging.sh
#
# Copyright (C) 2014 Kano Computing Ltd.
# License: http://www.gnu.org/licenses/gpl-2.0.txt GNU General Public License v2
#
# bash wrapper for kano.logging
# Usage:
#
# . /usr/share/kano-toolset/logger.sh
#
# set_app_name "make-minecraft"
#
# logger_write "Error! Error!"

APP_NAME="$0"

logger_set_app_name()
{
    export APP_NAME="$1"
}

logger_write()
{
    __msg="$1"
    __level=$2

    __kwargs=""
    if [ -n "$__level" ]; then
        kwargs="$__kwargs, level=\"$__level\""
    fi

    if [ -z "$LOG_LEVEL" ]; then
        LOG_LEVEL="`kano-logs config -s log_level`"
    fi

    if [ -z "$OUTPUT_LEVEL" ]; then
        OUTPUT_LEVEL="`kano-logs config -s output_level`"
    fi

    # Optimisation: Don't launch python unless logging is enabled
    if [ "$LOG_LEVEL" != "none" ] || [ "$OUTPUT_LEVEL" != "none" ]; then
        python <<EOF
from kano.logging import logger, normalise_level

logger._pid = $$
logger._cached_log_level = normalise_level("$LOG_LEVEL")
logger._cached_output_level = normalise_level("$OUTPUT_LEVEL")

logger.set_app_name("$APP_NAME")

logger.write("""$__msg""" $__kwargs)
EOF
    fi
}

logger_error() { logger_write "$1" "error"; }
logger_info()  { logger_write "$1" "info"; }
logger_warn()  { logger_write "$1" "warning"; }
logger_debug() { logger_write "$1" "debug"; }
