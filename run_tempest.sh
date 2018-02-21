#!/bin/bash -xe

test ! -f $SOURCE_FILE && \
    echo "Your keystonerc file should be mounted to $SOURCE_FILE" && \
    exit 1

source $SOURCE_FILE

if [ ! -d $LOG_DIR ]
then
    echo "------------WARNING------------"
    echo "-----Your log_dir is not mounted to $LOG_DIR-----"
    echo "-----$LOG_DIR will be created-----"
    echo "-----Be attention: if you've run the container with '--rm' key-----"
    echo "-----All reports will be erased-----"
    echo "-------------------------------"
    mkdir -p $LOG_DIR
fi

if [ -f $TEMPEST_CONF ]
then
    cp $TEMPEST_CONF /etc/tempest/tempest.conf
else
    echo "Please generate your tempest file"
    exit 1
fi

export TEMPEST_CONF=$CONF_FILE_PATH

if [ ! -f $LOG_DIR$SKIP_LIST ]
then
    if [ -f /var/lib/$SKIP_LIST ]
    then
        cp /var/lib/$SKIP_LIST $LOG_DIR$SKIP_LIST
    else
        echo "Please put your skip.list file to log_dir"
        exit 1
    fi
fi
export SKIP_LIST=$LOG_DIR$SKIP_LIST

if [ -n "${REPORT_SUFFIX}" ]
then
    report="report_${REPORT_SUFFIX}"
else
    report='report_'$SET'_'`date +%F_%H-%M`
fi


bash /etc/tempest/generate_resources
bash /etc/tempest/prepare

if [ -n "$CUSTOM" ]
then
    tempest run $CUSTOM
fi 
testr last --subunit | subunit2junitxml > verification.xml

