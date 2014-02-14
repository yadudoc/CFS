
cdo:
	cdo -f nc sellonlatbox,232,296,24,50 -remapnn,r4320x2160 tmin.01.2012110100.daily.grb2 tmin.nc

wget:
	wget --force-directories --cut-dirs 7 --input-file=wget.txt | tee wget.log

.PHONY: wget
