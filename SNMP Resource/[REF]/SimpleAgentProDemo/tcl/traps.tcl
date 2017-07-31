%init_action
    set counter 0
    SA_settrapmgrs 192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30,192.168.100.30


%timer_action 1
    incr counter
    if {$counter == 1} {
       SA_sendtrap { 1.3.6.1.4.1.786.1.1 2 0 { 1.3.6.1.2.1.2.2.1.1.1 Integer 1 }}
    } elseif {$counter == 2} {
       SA_sendtrap { 1.3.6.1.4.1.786.1.1 3 0 { 1.3.6.1.2.1.2.2.1.1.1 Integer 1 }}
       set counter 0
    }
