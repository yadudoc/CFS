#!/bin/bash

module load cdo
for prate in $(ls prate*)
do
    cdo daymean $prate ${prate/"06.time"/"00.time"}
done
