# pkgIndex.tcl - 
#
# md4 package index file
#
# This package has been tested with tcl 8.2.3 and above.
#
# $Id: s.pkgIndex.tcl 1.2 03/05/07 22:30:51-00:00 patthoyts $

if {![package vsatisfies [package provide Tcl] 8.2]} {return}
package ifneeded md4 1.0.1 [list source [file join $dir md4.tcl]]
