#!/bin/bash

#OUTPUT_FORMAT="grb2"
OUTPUT_FORMAT="nc4"

echo "Args passed : $* "
SOURCEFOLDER=$1
DESTFOLDER=$2

if [ -z "$SOURCEFOLDER" ] || [ -z "$DESTFOLDER" ]
then
    echo "USAGE $0 <sourcefolder> <destfolder>"
    exit 0
fi

for SOURCEFILE in $(ls $SOURCEFOLDER)
do
    INPUT=$(basename $SOURCEFILE)
    BASE=${INPUT%%.grb2}

    if [ ! -d $DESTFOLDER ]
    then
        mkdir -p $DESTFOLDER
    fi

    #which cdo
    module load cdo

    if   [ $OUTPUT_FORMAT == "grb2" ]
    then
        echo "cdo daymean $SOURCEFOLDER/$SOURCEFILE $DESTFOLDER/$BASE.grb2"
        cdo daymean $SOURCEFOLDER/$SOURCEFILE $DESTFOLDER/$BASE.grb2 && echo "CDO : SUCCESS"

    elif [ $OUTPUT_FORMAT == "nc4" ]
    then
        echo "cdo -f nc4 daymean $SOURCEFOLDER/$SOURCEFILE $DESTFOLDER/$BASE.nc4"
        cdo -f nc4 daymean $SOURCEFOLDER/$SOURCEFILE $DESTFOLDER/$BASE.nc4 && echo "CDO : SUCCESS"
    fi

done
