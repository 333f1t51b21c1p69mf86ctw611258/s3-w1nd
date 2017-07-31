#
# sample netflow file which turns debugging on
#
# this is another way to enable netflow instead of
# specifying it in the device properties.
#
%init_action
   # turn tcl debugging on
   set myIP [SA_getmyip]
   SA_settcldebugflag 1
   SA_settcldebugfile $myIP.netflow_tcl.dbg

   # read the netflow config file
   SA_netflow_readinputfile "..\\netflow\\sampleflow_v5.txt"

   # see netflow packet dumps in tcl debug file
   SA_netflow_setdebugflag 1

   # set the netflow collectors
   SA_netflow_setcollectors  192.168.100.99/9961

   # set the defaults if you need to overwrite
   #SA_netflow_setdefaults source_id 0
   #SA_netflow_setdefaults tcp_flags 1
   #SA_netflow_setdefaults src_mask 24
   #SA_netflow_setdefaults dst_mask 23
   #SA_netflow_setdefaults router_sc 192.168.100.2
   #SA_netflow_setdefaults maxflows 20
   #SA_netflow_setdefaults maxpktsize 2000

# every 10 seconds send a netflow packet to the collector
%timer_action 10
   # send the netflow packets
   SA_netflow_send
