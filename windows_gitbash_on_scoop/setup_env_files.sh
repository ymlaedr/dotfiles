#!/bin/bash



## -----------------------------------------------------------------------------
## 定数定義
## -----------------------------------------------------------------------------

TIMESTAMP=`date '+%Y%m%d%H%M%S'`

WORK_DIR=$(cd $(dirname $0); pwd)
BACKUP_DIR=${WORK_DIR}/backup/${TIMESTAMP}

LOGFILE_PATH=${WORK_DIR}/backup/${TIMESTAMP}/execution.log



## -----------------------------------------------------------------------------
## 共通処理
## -----------------------------------------------------------------------------

function execution_log() {
    if [ "$1" = '' ]; then
        echo 'invalid function call.'
    else
        echo $1
        echo $1 >> ${LOGFILE_PATH}
    fi
}

function replace() {
    TARGET_PATH=$1
    REPLACE_PATH=$2
    TARGET_NAME=${TARGET_PATH##*/}   ## `basename ${TARGET_PATH}`と同じ処理
    REPLACE_NAME=${REPLACE_PATH##*/} ## `basename ${REPLACE_PATH}`と同じ処理

    execution_log "deploying ${REPLACE_PATH}"

    ## 差分の比較
    diff -q ${TARGET_PATH} ${REPLACE_PATH} > /dev/null
    DIFF_RESULT=$?

    ## 同じものが存在する場合、何もしない
    if [ ${DIFF_RESULT} -eq 0 ]; then
        execution_log "same ${TARGET_NAME} already exists. do nothing."
    ## 異なるものが存在する場合、バックアップして上書き
    elif [ ${DIFF_RESULT} -eq 1 ]; then
        if [ -f ${TARGET_PATH} ]; then
            execution_log "${TARGET_NAME} exists. moving ${REPLACE_PATH}"
            mv ${TARGET_PATH} ${REPLACE_PATH}
        fi
        cp ${REPLACE_PATH} ${TARGET_PATH}
        execution_log "copied ${TARGET_NAME}"
    ## ファイルが存在しない場合、新規作成
    elif [ ${DIFF_RESULT} -eq 2 ]; then
        mkdir -p `dirname ${TARGET_PATH}`
        cp ${REPLACE_PATH} ${TARGET_PATH}
        execution_log "target file does not exist, created ${TARGET_PATH}"
    else
        execution_log "error occured. DIFF_RESULT: ${DIFF_RESULT}"
    fi
}



## -----------------------------------------------------------------------------
## メイン処理
## -----------------------------------------------------------------------------

mkdir ${BACKUP_DIR}

replace ${HOME}/.bashrc ${WORK_DIR}/envfiles/bashrc
replace ${HOME}/.ssh/config ${WORK_DIR}/envfiles/ssh_config
replace ${HOME}/config.xlaunch ${WORK_DIR}/envfiles/config_xlaunch.xml
