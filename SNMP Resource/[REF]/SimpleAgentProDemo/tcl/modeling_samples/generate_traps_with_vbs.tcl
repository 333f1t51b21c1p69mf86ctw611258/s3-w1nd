    #
    # Suppose you want to send a trap
    # which contains the current value of a variable from your MIB database,
    # when a set occurs on a variable
    # or send the same trap every 20 seconds, but with different values for one of the varbinds.
    #

%init_action

    # turn debugging on if required.  Remove it later
    # to get better performance
    #

    SA_settcldebugflag 1
    SA_settcldebugfile trapsample.dbg

    #
    # send a trap based on the value of a variable
    #

    set varbind [SA_getvar {myVariable.0}]
    set vb1 [lindex $varbind 0]
    set val1 [lindex $vb1 2]       
    SA_sendtrap [list 1.3.6.1.4.1.786.1.1 6 60 [list myVariable.0 Integer $val1]]

    #
    # send a trap when a set occurs on a variable
    #	

%after_set_action ifAdminStatus

    set varbind [SA_getreqvb]
    set curvb [lindex $varbind 0]
    set curoid [lindex $curvb 0]
    set curval [lindex $curvb 2]
 
    #
    # extract the instance component from the oid
    # (say everything beyond the 10th subid is instance
    #  since ifAdminStatus has 10 subids in
    #  the name)
    #

    set oidlist [split $curoid .]
    set instlist [lrange $oidlist 10 end ]
    set newindex [join $instlist . ]

    # check if value is set to enabled or disabled

    if {$curval == 1} {

        #
        # send link up trap
        #

        SA_sendtrap [list 1.3.6.1.4.1.786.1.1 3 0 [list ifIndex.$newindex Integer $newindex]]

    } elseif {$curval == 2} {

        #
        # send link down trap
        #

        SA_sendtrap [list 1.3.6.1.4.1.786.1.1 2 0 [list ifIndex.$newindex Integer $newindex]]

    }
	
    #
    # send 10 traps every 20 seconds, where the value of
    # one of the trap varbinds is changed
    #

%timer_action 20

    for {set i 0 } {$i < 10} {incr i} {

        SA_sendtrap [list 1.3.6.1.4.1.786.1.1 2 0 [list ifIndex.$i Integer $i]]

    }