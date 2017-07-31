#
# this script gets the ifSpeed for the specified interface 
# and then sets the ifInOctets and ifOutOctets values to 
# show less than 20% utilization

# ifSpeed     = 1.3.6.1.2.1.2.2.1.5
# ifInOctets  = 1.3.6.1.2.1.2.2.1.10      
# ifOctOctets = 1.3.6.1.2.1.2.2.1.16  

# specify the port for which you want to do this stuff
set iPort [lindex $SA_arg 0]
set mgr [lindex $SA_arg 1]

set oldmgr [SA_gettrapmgrs]
SA_settrapmgrs $mgr

# specify the percent utilization you want
set maxUtil 20

# get the port speed for this port by getting the value
# of ifSpeed.portnum
set varbind [SA_getvar [list 1.3.6.1.2.1.2.2.1.5.$iPort]]
set vb1 [lindex $varbind 0]
set speed [lindex $vb1 2]

# now the speed is in bits per second.  To get octets
# we need to divide by 8
set maxoct [expr $speed/8]

# now multiply max by utilization to get min increment
set minoct [expr [expr $maxoct / 100] * $maxUtil]

# now set the ifInOctets valuetype
SA_setvaltype [list [list 1.3.6.1.2.1.2.2.1.10.$iPort OctetString "timedrandomup(1000, $minoct)" ] ] 

# now set the ifOutOctets valuetype
SA_setvaltype [list [list 1.3.6.1.2.1.2.2.1.16.$iPort OctetString "timedrandomup(1000, $minoct)" ] ] 

#restore trap manager
SA_settrapmgrs $oldmgr
