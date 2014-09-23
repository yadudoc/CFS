#!/bin/bash

#FINAL="grb2"
#FINAL="nc4"
FINAL="nc"

if [ "$1" == "" ]
then
    #ARG1="__root__/scratch/midway/yadunand/CFS/convert_to_pSIMS/sample/prate/prate.1981121200.time.grb2"
    ARG1="__root__/scratch/midway/yadunand/CFS/convert_to_pSIMS/sample/prate/prate.1997073000.time.grb2"
else
    ARG1=$1
fi

if [ "$2" == "" ]
then
    ARG2="__root__/scratch/midway/yadunand/CFS/convert_to_pSIMS/merged_grb2"
else
    ARG2=$2
fi

SOURCE=$(basename $ARG1)
BASE=${SOURCE#prate.}
DEST=${ARG2#__root__}

echo "Args : $ARG1 $ARG2"
echo "Source : $SOURCE , $BASE"

#DIR=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/6hour
SDIR=$(dirname $(dirname $ARG1))
DIR=${SDIR#__root__}
echo "$DIR"
#VAR=prate.1982010100.time.grb2
#BASE=${VAR#prate\.}

perror () {
    echo "ERROR : $*"
    exit -1;
}

prate="$DIR/prate/prate.$BASE"    && [ ! -f "$prate"  ] && perror "$prate missing"
dswsfc="$DIR/dswsfc/dswsfc.$BASE" && [ ! -f "$dswsfc" ] && perror "$dswsfc missing"
tmax="$DIR/tmax/tmax.$BASE"       && [ ! -f "$tmax" ]   && perror "$tmax missing"
tmin="$DIR/tmin/tmin.$BASE"       && [ ! -f "$tmin" ]   && perror "$tmin missing"
wnd10m="$DIR/wnd10m/wnd10m.$BASE" && [ ! -f "$wnd10m" ] && perror "$wnd10m missing"

module load cdo

BASE=${BASE%%.grb2}
RESULT="$DEST/pSIMS.$BASE.$FINAL"
if [ -f $RESULT ]
then
    rm $RESULT
    echo "Removed $RESULT to recompute"
fi

if   [ "$FINAL" == "grb2" ]
then
    echo -e "cdo merge \n $prate \n $dswsfc \n $tmax \n $tmin \n $wnd10m \n $RESULT"
    cdo merge "$prate $dswsfc $tmax $tmin $wnd10m $RESULT" 2>&1

elif [ "$FINAL" == "nc" ]
then
    echo -e "cdo -f nc merge \n $prate \n $dswsfc \n $tmax \n $tmin \n $wnd10m \n $RESULT"
    cdo -f nc merge "$prate $dswsfc $tmax $tmin $wnd10m $RESULT" 2>&1

elif [ "$FINAL" == "nc4" ]
then
    echo -e "cdo -f nc4 merge \n $prate \n $dswsfc \n $tmax \n $tmin \n $wnd10m \n $RESULT"
    cdo -f nc4 merge "$prate $dswsfc $tmax $tmin $wnd10m $RESULT" 2>&1
    #cdo -f nc4 merge "$prate $dswsfc $tmax $tmin $wnd10m out.nc4" 2>&1
    #cdo remapcon,r768x380 $RESULT.nc4 $RESULT_remapped.nc4 2>&1
    #cdo -g t100grid -f nc4 merge "$prate $dswsfc $tmax $tmin $wnd10m TEST_$BASE.nc4" 2>&1
    #cdo remapcon,r768x380 $RESULT.nc4 $RESULT_remapped.nc4 2>&1
else
    echo "Unknown final formal [$FINAL] : Exiting with error"
    exit -1
fi
