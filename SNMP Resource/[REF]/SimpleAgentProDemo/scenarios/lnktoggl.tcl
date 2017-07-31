%MAPTCLSCRIPT
%init_action

    #
    # this script assumes that the map is made up of one
    # router (with display tag set to "router-1"), and a
    # bunch of devices connected to port 1, who will get
    # reconnected when port 1 connectivity is regained.
    #
    set rPort 1
    set trapEntId 1.3.6.1.4.1.786.1.1 

    #
    # get list of devices in the map
    #
    set deviceList [SA_getdevicelist]


    # set flag
    set flag 1

#
# every 10 seconds, toggle the port status
#
%timer_action 10

    #
    # loop through the list and make each device send the trap
    #
    foreach devname $deviceList {
        #
        # lock the device context
        #
        set results [SA_lockdevcontext $devname]
        if { [string first "Locked Device Context" $results] < 0 } {
            continue
        }

        #
        # get display tag
        #
        set dtag [SA_getdevicedisplaytag]

        if {$dtag == "router-1"} {

            # Router

            if {$flag == 1} {

                #
                # send link down trap for port
                #
                SA_sendtrap [list $trapEntId 2 0 [list 1.3.6.1.2.1.2.2.1.1.4.$rPort Integer $rPort ]]
                # 
                # update ifOperStatus for port to down
                #
                SA_setvaltype [list [list 1.3.6.1.2.1.2.2.1.8.$rPort OctetString "fixed(2)" ] ] 

            } else {

                #
                # send link up trap 
                #
                SA_sendtrap [list $trapEntId 3 0 [list 1.3.6.1.2.1.2.2.1.1.4.$rPort Integer $rPort ]]
                # 
                # update ifOperStatus to up
                #
                SA_setvaltype [list [list 1.3.6.1.2.1.2.2.1.8.$rPort OctetString "fixed(1)" ] ] 
           }

        } else {

            # downstream devices

            if {$flag == 1} {

               # 
               # disable ping for all downstream devices
               #
               SA_disableping

            } else {

               # 
               # enable ping for all downstream devices
               #
               SA_enableping

            }
        }
        
        #
        # release the device context
        #
        SA_releasedevcontext
    }

    if {$flag == 1} {
       set flag 2
    } else {
       set flag 1
    }
