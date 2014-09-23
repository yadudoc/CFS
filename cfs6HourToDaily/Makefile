
all:
	swift -tc.file apps -cdm.file midway.cdm -sites.file midway.xml -config swift.properties cfs6HourToDaily.swift \
	-6hour=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/6hour/ \
	-daily=/scratch/midway/yadunand/CFS/cfs6HourToDaily/cfs_all_daily/ #\
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/6hour/ #\
	-daily=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/daily/
#   /scratch/midway/yadunand/CFS/cfs6HourToDaily
clean:
	rm -rf *d *out *err *log *kml *swiftx *~
