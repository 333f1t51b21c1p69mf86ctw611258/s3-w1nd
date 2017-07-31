<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhcp_getoptions</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command returns the options part from the DHCP offer that was got when a DHCP simulated device got initialized.  The options are returned as a hex string.

Example:  set sname [SA_dhcp_getoptions]</Description>
 <OutputVariables></OutputVariables>
 <script>set sname [SA_dhcp_getoptions]</script>
</Template>
