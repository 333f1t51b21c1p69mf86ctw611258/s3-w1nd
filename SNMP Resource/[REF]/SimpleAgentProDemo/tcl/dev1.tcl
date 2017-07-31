# example of initial action that causes a cold start trap to
# be emitted to the associated trap manager.  The tcl debugging
# is also turned on.
%init_action
    SA_settcldebugflag 1
    SA_settcldebugfile dev1tcl.dbg
    set varbind [SA_getvar {sysObjectID.0}]
    set vb1 [lindex $varbind 0]
    set val1 [lindex $vb1 2]
    set args [list $val1 0 0 ]
    SA_sendtrap $args

# example of check action that causes a BAD_VALUE to be 
# returned for set requests to sysLocation.0
%check_set_action sysLocation.0
    SA_setcurstat 0

# example of set action that causes another variable to be also set
%after_set_action ifAdminStatus.1
    set varbind [SA_getreqvb]
    set curvb  [lindex $varbind 0]
    set curval [lindex $curvb 2]
    set args [list ifOperStatus.1 OctetString fixed($curval)]
    SA_setvaltype [list $args]

# example of get action that always returns ppppp as the value of 
# sysLocation.0, irrespective of the var file and previous set
# requests.
%getvalue_action sysLocation.0
    SA_setcurvalue ppppp

# example of timer based script execution that causes the
# script to be evaluated every 5 secs
%timer_action  5
    SA_sendtrap {1.2.3 6 55 }
    
