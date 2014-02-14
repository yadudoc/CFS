## CFS: Download data from the CFS archive and CFS2 rolling updates.

This is a collection of scripts for downloading data from both the CFS
(Climate Forecast System) archive and the CFS2 rolling updates.
Currently we are downloading a subset of CFS2 for the 1st and 15th
day of each month.

Scripts are tailored for clusters running SLURM but easily adapted to
any system.

## Scripts:

The R files are programs which process the data.
sbatch files are slurm-batch files, used for submitting jobs to the Midway
cluster.

scripts/cfs2.{sbatch,R} runs the daily download.  It checks that all
data from the previous six days has been downloaded.  This is one of
the jobs that we moved from my queue to yours (WHO ? / Joshua ?)

scripts/cfs2nmsu.R has to do with the data that we got from New Mexico
State University to backfill older data that was no longer available
on the official site.  That was a one-time operation.

scripts/cellNcCfs,R appears to be a work in progress.  It is hard-coded
to run on a single cell so is not generalized to the entire data set.
It would be used to build pSIMS files.

scripts/cfsArchive6hour.R is related to data/cfsr-rfl-ts9.  I forget what
that is but the URL is in the script. http://nomads.ncdc.noaa.gov/data/cfsr-rfl-ts9
Judgin from the time stamp we did not do anything with this since last April.

scripts/cfsrr.R puts the data from http://nomads.ncdc.noaa.gov/modeldata/cmd_ts_9mon
into data/cfsrr.

scripts/cfsArchive.sbatch appears to be a minor variant of cfsrr.sbatch

## Todo list:

* Code walkthrough
* Cleanup docs
* Test runs
* Move from custom slurm batch files to swift for better workflows.






