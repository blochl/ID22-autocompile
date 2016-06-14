#!/bin/bash

### CHANGE THESE ###
EXP="ma2916"
BINNINGS=( 0.001 0.002 0.003 )
TEMPRES_PATH=$HOME"/users/"$EXP"/id22/temp.res"

### CHANGE ONLY IF NEEDED ###
SUM_BIN_PATH="id31sum"
SUM_BIN_EXTRA_PARAMS="lowtth=0.5 scalmon gsas"
DAT_DIR=$HOME"/data1"
DEST_DIR=$HOME"/users/"$EXP"/id22/ALL_AUTOCOMPILED"

### DO NOT CHANGE FROM HERE ###
getscans() {
    local __IND_SCANS=$2
    local __IND_ENTRIES=$3
    local SCANS=($(grep "#S" $1 | awk '{print $2}'))
    local ENTRIES=${#SCANS[@]}
    for e in $(seq 1 $(($ENTRIES-1)))
    do
        if [ ${SCANS[$e]} -ne $((${SCANS[$e-1]}+1)) ]
        then
            printf "\e[41mERROR: check scan numbering in:\e[0m $1\n"
            exit 1
        fi
    done
    eval $__IND_SCANS="'${SCANS[@]}'"
    eval $__IND_ENTRIES="'${ENTRIES}'"
}

makedata() {
    for b in ${BINNINGS[@]}
    do
        echo "--- Binning $b ---"
        mkdir -p $DEST_DIR/$BASENAME/$1/bin_$b
        cp $TEMPRES_PATH $DEST_DIR/$BASENAME/$1/bin_$b/
        pushd $DEST_DIR/$BASENAME/$1/bin_$b
        $SUM_BIN_PATH ../../$FILENAME $b $2 $3 ${SUM_BIN_EXTRA_PARAMS}
        popd
    done
}


for f in ${DAT_DIR}/${EXP}*.dat
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "------------------------------"
    echo "Processing $BASENAME ..."
    echo "------------------------------"
    getscans $f IND_SCANS ENT
    SCANS=(${IND_SCANS})
    FIRST=${SCANS[0]}
    LAST=${SCANS[$ENT-1]}
    mkdir -p $DEST_DIR/$BASENAME
    cp $f $DEST_DIR/$BASENAME/
    for s in ${IND_SCANS[@]}
    do
        echo "##### Scan $s #####"
        makedata "Scan_$s" $s $s
    done
    if [ $FIRST -ne $LAST ]
    then
        echo "===== All Scans ====="
        makedata "All_scans" $FIRST $LAST
    fi
done
