    #
    # Following is an example of how tableB gets changed when rows get added/deleted in tableA. 
    # In this example, it is assumed that the column in tableA has 14 subids in its name (excluding the instance).
    #

%init_action
    #
    # turn debugging on to make sure script is working.
    # once it works, you might want to turn debugging
    # off to get better performance.
    #

    SA_settcldebugflag 1
    SA_settcldebugfile augment.dbg

    #
    # define procedures to be used later for adding
    # and deleting rows in dependent tables
    #

    #
    # table B
    #

    proc add_row_to_tableB { index } {

        SA_setvar [list [list tableBCol1.$index  Integer     1   ] \

                   [list tableBCol2.$index  OctetString 0x0102]]

    }

    proc del_row_from_tableB { index } {

        SA_deleterow tableBCol1.$index

    }


# check tableA for rowcreation requests for all instances.....

%after_all_set_action tableARowStatusCol

    set varbind [SA_getreqvb]
    set curvb [lindex $varbind 0]
    set curoid [lindex $curvb 0]
    set curval [lindex $curvb 2]

    #
    # extract the instance component from the oid
    # (say everything beyond the 14th subid is instance
    #  since tableARowStatus has 14 subids in
    #  the name)
    #

    set oidlist [split $curoid .]
    set instlist [lrange $oidlist 14 end ]
    set newindex [join $instlist . ]
 
    # check if createAndGo or Active

    if {$curval == 1 || $curval == 4} {

        # add row to tableB.....
        add_row_to_tableB $newindex

    } elseif {$curval == 6} {

        #row set to to destroy
        # delete row from tableB....

        del_row_from_tableB $newindex

    }