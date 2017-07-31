<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhcp_getservername</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command returns the server name from the DHCP offer that was got when a DHCP simulated device got initialized.

Example:  set sname [SA_dhcp_getservername]</Description>
 <OutputVariables></OutputVariables>
 <script>set sname [SA_dhcp_getservername]</script>
</Template>
