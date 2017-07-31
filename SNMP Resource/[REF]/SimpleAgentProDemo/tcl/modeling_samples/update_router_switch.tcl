    #
    # The device modeling file, in conjunction with the User data field allows you to share the same script, 
    # yet pass it arguments via the user data field of each device.  In this example, the associated Routers and 
    # Switches and their interfaces could be different for different devices, yet they could all share the same script
    # to dynamically update their associated MIB2 tables.  The sample tcl script shown below also shows 
    # how every 5 seconds you can have rows in a table appear and disappear using two methods.
    #
%init_action

    set myIP [SA_getmyip]
    set myMAC [SA_getmymac]
    set my_ed_flag 0
    set my_ad_flag 0

    #
    # turn tcl debugging on during development.  Afterwards
    # comment out these lines for better performance

    SA_settcldebugflag 1
    SA_settcldebugfile $myIP.tcl.dbg

    #
    # sample procedure to add/del rows from tcpConnTable
    # make sure the required columns are included in the set request
    #

    proc add_row_to_tcpConnTable { index } {

        SA_setvar [list [list tcpConnState.$index Integer 2 ] ]

    }

    proc del_row_from_tcpConnTable { index } {

        SA_deleterow tcpConnState.$index

    }

    #
    # sample procedure to convert hex mac address into subids.
    #

    proc getmacsubid { mac } {

        set macsubid ""

        for {set i 0} {$i < 12} {incr i 2} {

           if {$i != 0} {

               append macsubid .

           }

           set tmpid [string range $mac $i [expr $i+1]]

           scan $tmpid %x tmpintid

           append macsubid $tmpintid

        }

        return $macsubid

    }

    #
    # Now add our entry to the associated router's ARP cache.
    # The user data field has the name of the associated
    # router and port number information.  Make sure that the
    # associated router's var file has ipNetToMedia declared as
    # dynamic by having its dynamic row template enabled
    #

    # sample template

      # %drow  1.3.6.1.2.1.4.22.1   newinstance
      # %dcol  ipNetToMediaIfIndex       NotReq Integer      RW dfixed(1)
      # %dcol  ipNetToMediaPhysAddress   Req   OctetString  RW r_lastset(6, 6, 0x010203040506)
      # %dcol  ipNetToMediaNetAddress    NotReq IpAddress    RW dfixed(1.2.3.4)
      # %dcol  ipNetToMediaType          Req    Integer      RW r_lastset(1, 4, 1)
      # %setaction ipNetToMediaType      Integer   2  deleterow()
      #

    # Add a row to ipNetToMedia Table with

      # ipNetToMediaPhysAddress(1.3.6.1.2.1.4.22.1.2) set to our mac
      # ipNetToMediaType(1.3.6.1.2.1.4.22.1.4) set to 3 (dynamic)

   # and instance set to <router interface>.<our ip>

    set routerip   [SA_gettokenfromuserdata "ROUTER_IP"]
    set routerport [SA_gettokenfromuserdata "ROUTER_IF"]

    if {$routerip != ""} {

       SA_sendsnmp $routerip 161 SNMPv1 set private [list \

          [list 1.3.6.1.2.1.4.22.1.2.$routerport.$myIP OctetString $myMAC] \

          [list 1.3.6.1.2.1.4.22.1.4.$routerport.$myIP Integer 3] ]

    }         

    #
    # Now add our entry to the associated switch's transparent
    # bridging table. The user data field has the name of the
    # associated switch and port number information.  Make sure
    # that the associated switches var file has dot1dTpFdbTable
    # declared as dynamic by having its dynamic row template enabled
    #

    # sample template

       # %drow  1.3.6.1.2.1.17.4.3.1   newinstance
       # %dcol  dot1dTpFdbAddress         NotReq OctetString  RO dfixed(0x010203040506)
       # %dcol  dot1dTpFdbPort            Req    Integer      RW lastset(1)
       # %dcol  dot1dTpFdbStatus          NotReq Integer      RW lastset(1)
       # %setaction dot1dTpFdbStatus      Integer      2 deleterow()
       #

    # Add a row to dot1dTpFdbTable with

       # dot1dTpFdbPort(1.3.6.1.2.1.17.4.3.1.2) set to switch's portnum
       # dot1dTpFdbStatus(1.3.6.1.2.1.17.4.3.1.3) set to 3 (learned)

    # and instance set to our mac

    set switchip   [SA_gettokenfromuserdata "SWITCH_IP"]
    set switchport [SA_gettokenfromuserdata "SWITCH_IF"]

    if {$switchip != ""} {

       set macid [getmacsubid $myMAC]

       SA_sendsnmp $switchip 161 SNMPv1 set private [list \

          [list 1.3.6.1.2.1.17.4.3.1.2.$macid Integer $switchport] \

          [list 1.3.6.1.2.1.17.4.3.1.3.$macid Integer 3] ]

    }         

   #
   # example of get action that overwrites the value
   # type information in the variable file.
   #

%getvalue_action tcpConnState

    #
    # generate a random number between 1 and 11
    #

    set a_number [expr [expr int([expr rand()] * 11)] + 1]
    SA_setcurvalue $a_number
                    
    #
    # example timer based script that is evaluated every 5 secs
    #

%timer_action  5

    #
    # to have rows come and go in the tcpConnetion table,
    # the variable file should define this table as dynamic
    # It should have the following template enabled...
    #

    # template for dynamic row. To use, please remove the starting hash signs

       # %drow  1.3.6.1.2.1.6.13.1   newinstance
       # %dcol  tcpConnState              Req    Integer      RW r_lastset(1, 12, 1)
       # %dcol  tcpConnLocalAddress       NotReq IpAddress    RO dfixed(1.2.3.4)
       # %dcol  tcpConnLocalPort          NotReq Integer      RO dfixed(0)
       # %dcol  tcpConnRemAddress         NotReq IpAddress    RO dfixed(1.2.3.4)
       # %dcol  tcpConnRemPort            NotReq Integer      RO dfixed(0)
       # %setaction tcpConnState          Integer      12 deleterow()
       #

    # in this example, existing rows in tcpConnection table
    # appear and disappear.  This is more efficient than
    # adding and deleting rows. Note that these rows already
    # exist in the variable file
    #

    if {$my_ed_flag == 0} {

        SA_disablerow tcpConnLocalAddress.1.2.3.4.1.1.2.3.4.2

        SA_disablerow tcpConnLocalAddress.1.2.3.4.1.1.2.3.4.4

        set my_ed_flag 1

    } else {

        SA_enablerow tcpConnLocalAddress.1.2.3.4.1.1.2.3.4.2

        SA_enablerow tcpConnLocalAddress.1.2.3.4.1.1.2.3.4.4 

        set my_ed_flag 0

    } 

    #
    # in this example, new rows are added and deleted from the
    # tcpConnection table. Since SAPro has to do validation
    # of set request and allocate memory, this requires more
    # CPU resources.
    #

    if {$my_ad_flag == 0} {

        add_row_to_tcpConnTable 192.168.100.20.161.10.10.1.1.2000

        add_row_to_tcpConnTable 192.168.100.21.2004.10.10.1.5.2009

        set my_ad_flag 1

    } else {

        del_row_from_tcpConnTable 192.168.100.20.161.10.10.1.1.2000

        del_row_from_tcpConnTable 192.168.100.21.2004.10.10.1.5.2009

        set my_ad_flag 0

    }  