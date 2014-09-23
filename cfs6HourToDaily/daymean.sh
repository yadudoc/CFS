#!/bin/bash

OUTPUT_FORMAT="grb2"
#OUTPUT_FORMAT="nc4"

echo "Args passed : $* "
SOURCEFILE=$1
DESTFOLDER=$2

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
    echo "cdo daymean $SOURCEFILE $DESTFOLDER/$BASE.grb2"
    cdo daymean $SOURCEFILE $DESTFOLDER/$BASE.grb2 && echo "CDO : SUCCESS"

elif [ $OUTPUT_FORMAT == "nc4" ]
then
    echo "cdo -f nc4 daymean $SOURCEFILE $DESTFOLDER/$BASE.nc4"
    cdo -f nc4 daymean $SOURCEFILE $DESTFOLDER/$BASE.nc4 && echo "CDO : SUCCESS"
fi
