%MAPTCLSCRIPT
%init_action

    #
    # get list of devices in the map
    #
    #
    # get list of devices in the map
    #
    set deviceList [SA_getrunningdevicelist]
    #
  # loop through the list and make each device send the trap 
  #
  foreach devname $deviceList {
      #
      # lock the device context
      #
      SA_lockdevcontext $devname
      #
      # send the trap
      #
      SA_settrapudpport 162
      SA_settrapmgrs 127.0.0.1
      SA_settrapcommunity public
      SA_settrapcount 1
      SA_sendtrap { 1.3.6.1.4.1.786.1.1 2 0 { 1.3.6.1.2.1.2.2.1.1.1 Integer 1 }}

      #
      # release the device context
      #
      SA_releasedevcontext
  }

