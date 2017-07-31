####################################################
#
# Sample SNMPv1 trap tcl commands are created from Mib2.cmf
#
####################################################
####################################################
# Change the enterprise id (1.3.6.1.4.1.786.1.1) in the
# standard traps to the value of sysObjectId for your agent.
####################################################
##TRAP=cold start
SA_sendtrap { 1.3.6.1.4.1.786.1.1 0 0 }
##TRAP=warm start
SA_sendtrap { 1.3.6.1.4.1.786.1.1 1 0 }
##TRAP=link down
SA_sendtrap { 1.3.6.1.4.1.786.1.1 2 0 { 1.3.6.1.2.1.2.2.1.1.1 Integer 1 }}
##TRAP=link up
SA_sendtrap { 1.3.6.1.4.1.786.1.1 3 0 { 1.3.6.1.2.1.2.2.1.1.1 Integer 1 }}
##TRAP=authentication failure
SA_sendtrap { 1.3.6.1.4.1.786.1.1 4 0 }
##TRAP=egpNeighbor loss
SA_sendtrap { 1.3.6.1.4.1.786.1.1 5 0 { 1.3.6.1.2.1.8.5.1.2.1.2.3.4 IpAddress 1.2.3.4 }}
####################################################
