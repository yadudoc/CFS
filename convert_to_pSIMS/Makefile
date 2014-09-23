
all:
	swift -tc.file apps -sites.file midway.xml -config swift.properties convert_to_pSIMS.swift \
	-daily=/scratch/midway/yadunand/CFS/convert_to_pSIMS/sample/ \
	-output=/scratch/midway/yadunand/CFS/convert_to_pSIMS/output/
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rf /
#	-output=/scratch/midway/yadunand/CFS/convert_to_pSIMS/merged_grb2
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rf/ \
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rf/ \
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/6hour/ #\
#	-daily=/project/joshuaelliott/cfs/data/cfsr-rfl-ts9/prate/daily/
#   /scratch/midway/yadunand/CFS/cfs6HourToDaily
clean:
	rm -rf *d *out *err *log *kml *swiftx *~ run0*
