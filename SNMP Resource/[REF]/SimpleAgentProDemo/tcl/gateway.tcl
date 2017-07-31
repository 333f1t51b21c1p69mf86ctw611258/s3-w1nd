%init_action
    #
    # turn debugging on to make sure script is working.
    # once it works, you might want to turn debugging
    # off to get better performance.
    #
    SA_settcldebugflag 1
    SA_settcldebugfile gateway.dbg
    #
    # overwrite my current var file and make it appear
    # as if I am a gateway for all the simulated devices
    # by adding fake interfaces to me and including all
    # the simulated devices in my arp cache
    SA_updatemygatewayinfo
