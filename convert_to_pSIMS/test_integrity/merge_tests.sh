#!/bin/bash

if [ "$1" == "" ]
then
    BASE="1982010100.time.grb2"
else
    BASE=$1
fi

#DIR=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/6hour
DIR=/project/joshuaelliott/cfs/data/cfsr-rf
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
cdo merge \
    "$prate" \
    "$dswsfc" \
    "$tmax" \
    "$tmin" \
    "$wnd10m" \
    ./merged.grb2
