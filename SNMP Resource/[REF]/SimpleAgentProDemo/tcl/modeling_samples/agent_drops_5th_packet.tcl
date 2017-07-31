%init_action
    # 
    #simulate a condition where an agent drops some of the packets it receives
    #

    # set these variables if you want to specify the pattern
    # of failed/(total = fail+successful) responses.
    #  eg: 1 in 5, myPatternFail = 1, myPatternTotal = 5
    #  eg: 3 in 7, myPatternFail = 3, myPatternTotal = 7
    #

    set myPatternFlag     1
    set myPatternFail     1
    set myPatternTotal    5
    set myPatternCounter  0

    #
    # this script segment should create the pattern of
    # fail/(total = fail+successful) response
    #

%before_snmp_request

    if { $myPatternFlag == 1 } {

        incr myPatternCounter
        if { $myPatternCounter <= $myPatternFail } {

            #
            # setting the error to a special value of
            # 9999 will cause this request to be dropped.
            #

            SA_seterrorstatus 9999

        }

        if { $myPatternCounter >= $myPatternTotal } {

            set myPatternCounter 0

        }

    }