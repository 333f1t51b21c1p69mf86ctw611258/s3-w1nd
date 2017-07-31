# this file turns snmp debugging on
%init_action
    set myIP [SA_getmyip]
    SA_setsnmpdebugflag 2
    SA_setsnmpdebugfile snmp_$myIP.dbg
