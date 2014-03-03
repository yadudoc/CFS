## CFS: Download data from the CFS archive and CFS2 rolling updates.

This is a collection of scripts for downloading data from both the CFS
(Climate Forecast System) archive and the CFS2 rolling updates.
Currently we are downloading a subset of CFS2 for the 1st and 15th
day of each month.

Scripts are tailored for clusters running SLURM but easily adapted to
any system.

### Tasks outlined here :

Google doc : https://docs.google.com/document/d/1Kq5ehxSW-d_yeYFAXUdlYT961k4ymD5nYPE0V3XBJi4/edit

### Overview:

This project periodically downloads climate data and performs data transforms
to prep it for the processing stages downstream in the PSIMS workflow.

The data downloaded is time series of climate data so it could be represented
as a 3 dimensional array => climate_data[timestamp][lattitude][longitude] ?


### Scripts:

The R files are programs which process the data.
sbatch files are slurm-batch files, used for submitting jobs to the Midway
cluster.

***scripts/cfs2.{sbatch,R}*** runs the daily download.  It checks that all
data from the previous six days has been downloaded.  This is one of the
jobs that we moved from my queue to (Joshua ?). The script generates
the strings for wget to download appropriate files.

***scripts/cfs2nmsu.R*** has to do with the data that we got from New
Mexico State University to backfill older data that was no longer
available on the official site.  That was a one-time operation. This
script works much like cfs2.R, in generating wget strings and using DoMC
foreach to do parallel downloads.

***scripts/cellNcCfs,R*** appears to be a work in progress.  It is hard-coded
to run on a single cell so is not generalized to the entire data set.
It would be used to build pSIMS files.

scripts/cfsArchive6hour.R is related to data/cfsr-rfl-ts9.  I forget what
that is but the URL is in the script. http://nomad;s.ncdc.noaa.gov/data/cfsr-rfl-ts9
Judging from the time stamp we did not do anything with this since last April.

scripts/cfsrr.R puts the data from http://nomads.ncdc.noaa.gov/modeldata/cmd_ts_9mon
into data/cfsrr. This script does not appear to be just doing downloads.

scripts/cfsArchive.sbatch appears to be a minor variant of cfsrr.sbatch

### Todo list:

* Code walkthrough
* Cleanup docs
* Test runs
* Move from custom slurm batch files to swift for better workflows.


* What is the cdo command used in the Makefile ? Is the Makefile used to drive the workflows ?





###Dataset definitions:

cfsr-rf: CFS reforecast product
 - four 9 month forecasts produced ex post facto every 
     5 days, labelled [00,06,12,18]
 - we have only ingested the 00 set as of 6/2013 so there 
     are additional 9 month forecasts if needed for ensemble
     studies in future. 
 - current holdings are about 650 gb raw data for the 00 set
 - starting 12-12-1981 and ending 03-27-2011
 - uses the CSF v2 model run in reforecast mode
 - prate variable missing for most years from the daily 
     archive so we have supplemented it with 6 hourly precip 
     data from cfsr-rfl which we aggregate to daily ourselves

cfs2: CFS real-time forecast archive
 - 16 forecasts each day: [00,06,12,18]/time_grib_[1-4]
 - [00,06,12,18]/time_grib_1 are all 9 month forecasts
 - 00/time_grib_[2-4] are all "one season runs" which 
     should be 123 days or about 4 months
 - [06,12,18]/time_grib_[2-4] are all 45 day runs
 - runs started 03-2011 but forecasts were not archived
 - we have kept a live archive of all runs since 02-27-2013
 - archive is about 3 gb per day raw = about 1 tb per year

variables:
 var    - unit   - name
-----------------------------------------
 tmax   - C      - max temperature
 tmin   - C	 - min temperature
 prate  - mm/day - precipitation rate
 dswsfc -	 - downward shortwave solar
 wnd10m -	 - windspeed at 10m (u and v components)
 q2m    -        - specific humidity 

Not currently downloaded:
cfsr: CFS reanalysis product
 - a single cfs v2 model run forced by observations 
    over the period 1979-2009. 
