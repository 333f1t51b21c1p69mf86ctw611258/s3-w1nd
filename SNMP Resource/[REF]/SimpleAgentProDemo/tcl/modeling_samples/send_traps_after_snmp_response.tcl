   #
   # The tcl processing in the %after_set_action etc gets done before the response is actually generated
   # and sent to the manager.  If the tcl processing takes a long time, the manager might timeout. 
   # Also sometimes, a trap etc might have to be sent after the SNMP response. 
   # To facilitate that, the %after_snmp_response entry point has been added.
   #

%init_action

   SA_settcldebugflag 1
   SA_settcldebugfile abc.tcl.dbg
   set lastoid 0
   set lastval 0
   
   #
   # process set request
   #

%after_set_action someVariableABC

    set varbind [SA_getreqvb]
    set curvb   [lindex $varbind 0]

    #
    # just save the state and move on…
    #

    set lastoid [lindex $curvb 0]
    set lastval [lindex $curvb 2]
    SA_setafterresponseid 1
 
    #	
    # process set request for some other variable
    #

%after_set_action someVariablePQR

    set varbind [SA_getreqvb]
    set curvb   [lindex $varbind 0]

    #
    # just save the state and move on…
    #

    set lastoid [lindex $curvb 0]
    set lastval [lindex $curvb 2]

    SA_setafterresponseid 2
    
    #
    # actually do additional work, now that SNMP response
    # has been sent…
    #

%after_snmp_response

    set myid [SA_getafterresponseid]

    if {$myid == 1} {

      #
      # do work for setting someVariableABC                                                 
      #

      SA_setafterresponseid 0

    } elseif {$myid == 2 }  {

      #
      # do work for setting someVariablePQR                                                 
      #

      SA_setafterresponseid 0

   }