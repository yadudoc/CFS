#!/usr/bin/env python

import glob
import os.path
import urllib

#NOMAD="http://nomads.ncdc.noaa.gov/modeldata/cmd_ts_9mon"
NOMAD="http://nomads.ncdc.noaa.gov/data/cfsr-rfl-ts9/prate/"

var = dict()
var["dswsfc"] = [ x.split("/")[-1].replace("dswsfc.","") for x in glob.glob("/project/joshuaelliott/cfs/data/cfsr-rf/dswsfc/*grb2") ]
var["tmax"]   = [ x.split("/")[-1].replace("tmax.","")   for x in glob.glob("/project/joshuaelliott/cfs/data/cfsr-rf/tmax/*grb2") ]
var["tmin"]   = [ x.split("/")[-1].replace("tmin.","")   for x in glob.glob("/project/joshuaelliott/cfs/data/cfsr-rf/tmin/*grb2") ]
var["wnd10m"] = [ x.split("/")[-1].replace("wnd10m.","") for x in glob.glob("/project/joshuaelliott/cfs/data/cfsr-rf/wnd10m/*grb2") ]
var["prate"]  = [ x.split("/")[-1].replace("prate.","")  for x in glob.glob("/project/joshuaelliott/cfs/data/cfsr-rf/prate/*grb2") ]

s_dswsfc = set(var["dswsfc"])
s_tmax   = set(var["tmax"])
s_tmin   = set(var["tmin"])
s_wnd10m = set(var["wnd10m"])
s_prate  = set(var["prate"])

if s_dswsfc == s_tmax :
    print "Set dswsfc == Set tmax"
else:
    print "Set dswsfc != Set tmax"

if s_tmin   == s_tmax :
    print "Set tmin   == Set tmax"
else:
    print "Set tmin   != Set tmax"

if s_wnd10m == s_tmax :
    print "Set wnd10m == Set tmax"
else:
    print "Set wnd10m != Set tmax"

if s_prate == s_tmax :
    print "Set prate  == Set tmax"
else:
    print "Set prate  != Set tmax"

print '-'*80
print "Files missing in prate,  count :", len(s_tmax-s_prate)


def download (url, destination):
    # Urllib.urlretrieve does not return an error code if download failed
    # determine download success from checking destination instead
    print "Download : " + url + "to : " + destination ,
    ret = urllib.urlretrieve (url, destination)
    if os.path.isfile(destination) :
        print "Success"
        return True
    else:
        print "Failed"
        return False


#download("http://nomads.ncdc.noaa.gov/data/cfsr-rfl-ts9/prate/198911/prate.1989110206.time.grb2", "prate.1989110206.time.grb2")
#download("http://nomads.ncdc.noaa.gov/data/cfsr-rfl-ts9/prate/198911/prate.1989110200.time.grb2", "prate.1989110200.time.grb2")


failed_list = []
prate_dir="/project/joshuaelliott/cfs/data/cfsr-rf/prate"
for miss in (s_tmax-s_prate):
    if os.path.isfile(prate_dir+"/prate."+miss) == True:
        continue
    print "Missing file : {0}/prate.{1}".format(prate_dir,miss)
    #date extracted from filenames are in the format
    # yyyymmdd{00,06,12,16}
    date=int(miss.split(".")[0])

    # Prate data is under folders named as yyyymm
    URL=NOMAD + str(int(date/10000)) + "/"

    flag = False
    for timeofday in [6,12,18]:
        download_url = URL + "prate." + str(date+timeofday) + ".time.grb2"
        if download ( download_url, "prate." + str(date+timeofday) + ".time.grb2" ) :
            flag = True
            break

    if flag == False :
        print "All download attempts for prate." + miss + " failed"
        failed_list.append(miss)
    #prate_matcher =  prate_dir+"/prate."+str(int(date/100))+"*"
    #print "Attempt match on : "+ prate_matcher
    #print glob.glob(prate_matcher)
print "Failed to download from NOAA : " + str(len(failed_list))
for miss in failed_list:
    print miss
