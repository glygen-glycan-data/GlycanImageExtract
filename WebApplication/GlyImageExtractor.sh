#!/bin/bash

SERVICE=GlyImageExtractor
FLASK_APP=./${SERVICE}.py

start() {
	echo -n "Starting ${SERVICE}: "
	export FLASK_APP
	export FLASK_ENV=development
        nohup .venv/bin/python ${FLASK_APP} > ${SERVICE}.log 2>&1 &
	RETVAL=$?
	echo "done."
	return $RETVAL
}	

stop() {
	echo -n "Shutting down ${SERVICE}: "
	PIDS=`ps -ef | fgrep -w ${FLASK_APP} | fgrep -v grep | awk '{print $2}'`
	if [ "$PIDS" != "" ]; then
	  kill -9 `ps -ef | fgrep -w ${FLASK_APP} | fgrep -v grep | awk '{print $2}'`
	  RETVAL=$?
	else
	  RETVAL=0
	fi
        echo "done."
	return $RETVAL
}

status() {
	ps -ef | fgrep -w ${FLASK_APP} | fgrep -v grep
	RETVAL=$?
	return $RETVAL
}

case "$1" in
    start)
	start
	RETVAL=$?
	;;
    stop)
	stop
	RETVAL=$?
	;;
    restart)
	stop || true
	start
	RETVAL=$?
	;;
    status)
	status
	RETVAL=0
	;;
    *)
	echo "Usage: $SERVICE {start|stop|restart|status}"
	exit 1
	;;
esac
exit $RETVAL
