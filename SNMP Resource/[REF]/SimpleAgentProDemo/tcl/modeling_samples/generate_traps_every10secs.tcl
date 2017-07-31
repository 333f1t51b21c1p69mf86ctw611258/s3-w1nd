    #
    # Suppose you want to generate a different trap every 10 seconds. 
    # You could create a modeling file that looks like this:
    #

%init_action
    #
    # turn debugging on to make sure script is working.
    # once it works, you might want to turn debugging
    # off to get better performance.
    #

    SA_settcldebugflag 1
    SA_settcldebugfile example2.dbg

%timer_action 10

    #
    # generate a random number between 0 and 4
    #

    set newnumber [expr int([expr rand()] * 5)]

    if {$newnumber == 0} {

        #
        # send trap 1
        #

        SA_sendtrap { 1.2.3 6 52 }

    } elseif {$newnumber == 1} {

        #
        # send trap 2
        #

       SA_sendtrap { 1.2.3 6 52 }

    } elseif {$newnumber == 2} {

        #
        # send trap 3
        #

       SA_sendtrap { 1.2.3 6 53 }

    } elseif {$newnumber == 3} {

        #
        # send trap 4
        #

       SA_sendtrap { 1.2.3 6 54 }

    } elseif {$newnumber == 4} {

        #
        # send trap 5
        #

       SA_sendtrap { 1.2.3 6 55 }

    }