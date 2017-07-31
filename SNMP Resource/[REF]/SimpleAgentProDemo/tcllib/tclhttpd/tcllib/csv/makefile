LINCDIRS =
SOURCES = 
OTHERS = \
	csv.tcl \
	pkgIndex.tcl
LIBS = 
SUBDIRS =

include $(SMS_BLDROOT)/makeglo

local : objects 
	mkdir -p $(SMS_EXECROOT)/../tcllib/tclhttpd/tcllib/csv
	cp -f csv.tcl $(SMS_EXECROOT)/../tcllib/tclhttpd/tcllib/csv
	cp -f pkgIndex.tcl $(SMS_EXECROOT)/../tcllib/tclhttpd/tcllib/csv

