    #
    # In this tcl example, the script does a getnext walk to determine all the existing rows
    # and retrieves the largest index, and when the set occurs on a particular variable, 
    # a new row gets added to the table.
    #

%init_action

    #
    # turn debugging on to make sure script is working.
    # once it works, you might want to turn debugging
    # off to get better performance.
    #

    set myIP [SA_getmyip]
    SA_settcldebugflag 1
    SA_settcldebugfile $myIP.tcl.dbg

    #
    # define procedures to be used later for adding rows
    #

    proc add_row_to_tableB { index } {

        SA_setvar [list [list tableBCol1.$index  Integer     1   ] [list tableBCol2.$index  OctetString 0x0102]]

    }

    #
    # procedure to get the max index in the table
    # assumes that index is the last subid in the instance.
    #

    proc get_max_index { } {

       #
       # walk through the table till the end is reached.
       #
       # set firstoid to tableBCol1(1.3.6.1.4.1.786.1.1.1)

       set firstoid 1.3.6.1.4.1.786.1.1.1
       set forever 1
       set lastoid $firstoid
       while { $forever } {

           if [catch {SA_gnextvar [list $lastoid]} varbind] {
               break

           }

           set curvb [lindex $varbind 0]
           set curoid [lindex $curvb 0]
           set retval [string first $firstoid $curoid]
           if { $retval == -1 } {
               break

           }

           set lastoid $curoid

       }

       #
       # extract the instance component from the oid
       #

       if {$lastoid == $firstoid} {
           return 0

       }

       set oidlist [split $lastoid .]
       set inst [lindex $oidlist end ]
       return $inst

   }


   #
   # check for set requests for someOtherVariable
   #

%after_all_set_action someOtherVariable

    set varbind [SA_getreqvb]
    set curvb [lindex $varbind 0]
    set curoid [lindex $curvb 0]
    set curval [lindex $curvb 2]

    #
    # check if the value is ipsec.1
    #

    if {$curval == "specificValue"} {

        #
        # get max row index
        #

        set maxVal [get_max_index]
        set newindex [expr $maxVal + 1]

        #
        # add row to tableB.....
        #

        add_row_to_tableB $newindex

    }