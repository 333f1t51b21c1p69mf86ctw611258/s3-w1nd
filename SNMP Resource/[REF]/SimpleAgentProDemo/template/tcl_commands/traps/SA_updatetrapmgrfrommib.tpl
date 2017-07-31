<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_updatetrapmgrfrommib</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the list of trap receipient managers from the snmpTargetAddr Table, and uses the value of  snmpTargetAddrTAddress to get the IP address and port.  This function can be used in the init_action section of the tcl modeling file to use existing rows of the table from the var file and then in the after_set_action of the snmpTargetAddrTable to update it with the changes made.

Example: SA_updatetrapmgrfrommib </Description>
 <OutputVariables></OutputVariables>
 <script>SA_updatetrapmgrfrommib </script>
</Template>
