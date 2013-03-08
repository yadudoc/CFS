library( stringr, quietly= TRUE)
library( doMC, quietly= TRUE)
library( lubridate)

registerDoMC( cores= multicore:::detectCores())
## options( internet.info= 0)


## noClobber currently has no effect

## TODO: implement forced overwrite for if( noClobber)

noClobber <- TRUE

baseUrl <- "http://nomads.ncdc.noaa.gov/data/cfsr-rfl-ts9"

cfsVars <- "prate"

## CFS archive does not account for leap days, so the sequence is
## somewhat irregular

everyThirtyJulianDaysNoLeapDays <- function( year) {
  interval <- c(
    1, 30,
    ifelse( leap_year( year), 31, 30),
    rep( 30, times= 9))
  days <- cumsum( interval)
  dates <- as.POSIXct( paste( year, days), format= "%Y %j", tz= "GMT")
  names( dates) <- sprintf( "%4d.%02d", year, days %/% 30 + 1)
  dates
}
              
cfsDates <- foreach(
  year= 1982:2009,
  .combine= c) %do% {
    everyThirtyJulianDaysNoLeapDays( year)
  }

cfsDates <-
  cfsDates[  cfsDates >= ISOdatetime( 1982,  1,  1, 0, 0, 0, "GMT")
           & cfsDates <= ISOdatetime( 2009, 12, 27, 0, 0, 0, "GMT")]

writeCfsUrls <- function( cfsVar, cfsDate, md5= FALSE) {
  cfsUrlFormat <- paste(
    cfsVar,
    "%Y%m",
    paste( cfsVar, "%Y%m%d%H", "time", "grb2", sep= "."),
    sep= "/")
  cfsFileUrl <- strftime(
    cfsDate, tz= "GMT",
    format= cfsUrlFormat)
  if( md5) {
    paste( cfsFileUrl, "md5", sep= ".")
  } else {
    cfsFileUrl
  }
}


cfsUrls <-
  foreach( cfsVar= cfsVars,
          .combine= c) %:%
  foreach( cfsDate= cfsDates,
          .combine= c) %dopar% {
    writeCfsUrls( cfsVar, cfsDate)}

## cfsMd5Urls <-
##   foreach( cfsVar= cfsVars,
##           .combine= c) %:%
##   foreach( cfsDate= cfsDates,
##           .combine= c) %dopar% {
##     writeCfsUrls( cfsVar, cfsDate, md5= TRUE)}

cfsWgetCommands <-
  paste(
    "wget",
    "--recursive",
    "--progress=dot:mega", ## "--no-verbose",
    "--retry-connrefused",
    "--continue",
    ## "--password=nbest@ci.uchicago.edu",
    "--timestamping",
    "--no-host-directories",
    "--cut-dir 1",
    cfsUrls,
    "2>&1")

setwd( "data")

foreach(
  cfsWgetCommand= cfsWgetCommands) %dopar% {
    cat( system( cfsWgetCommand, intern= TRUE), sep= "\n")
  }


## TODO: create symlinks to name by pseudo-months