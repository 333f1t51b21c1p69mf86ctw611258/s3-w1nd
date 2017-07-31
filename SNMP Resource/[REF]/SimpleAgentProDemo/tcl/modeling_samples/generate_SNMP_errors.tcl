    #
    # The SimpleAgentPro can be set up to generate a variety of errors, so that you management applications 
    # can be tested against them.  A sample modeling file that generates some of the errors is shown below:
    #

%init_action

    #
    # turn debugging on to see what is happening.
    # for better performance, once the script is
    # working, you can turn it off

    set myIP [SA_getmyip]
    SA_settcldebugflag 1
    SA_settcldebugfile tcl_$myIP.dbg

    #
    # example where each request will generate multiple
    # responses (this case 3). To reset it back, set it to 1.
    #

    SA_setnumresponses 3

    #
    # example where there is no response sent
    # when a get is made on sysDescr.0
    #

%getvalue_action sysDescr.0

    SA_seterrorstatus 9999

    #
    # example where there is an error sent when a get is
    # made on sysObjectID.0.  Some v1 errors are 
    #      tooBig     (1)
    #      noSuchName (2)
    #      badValue   (3)
    #      readOnly   (4)
    #      genError   (5)
    #

%getvalue_action sysObjectID.0

    SA_seterrorstatus 5

    #
    # example where a particular varbind is skipped in
    # the response.  This one skips sysUptime.0
    #

%getvalue_action sysUpTime.0

    SA_setskipcurvbflag 1

    #
    # example where there is ovewriting of values in the
    # var file.  This one changes value component
    # when a get is made on sysContact.0
    #

%getvalue_action sysContact.0

    SA_setcurvalue ppppp

    #
    # example where there is ovewriting of values in the
    # var file.  This one changes datatype component
    # when a get is made on sysName.0
    #

%getvalue_action sysName.0

    SA_setcurtype Integer

    #
    # example where there is ovewriting of values in the
    # var file.  This one changes oid component
    # when a get is made on sysLocation.0
    #

%getvalue_action sysLocation.0

    SA_setcuroid 1.3.6.1.2.1.1.2.0

   #
   # example where the request id in the response is
   # made different from the request id
   #

%getvalue_action sysServices.0

    SA_setreqid 54321