<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhcp_getfilename</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command returns the boot file name from the DHCP offer that was got when a DHCP simulated device got initialized.

Example:  set fname [SA_dhcp_getfilename]</Description>
 <OutputVariables></OutputVariables>
 <script>set fname [SA_dhcp_getfilename]</script>
</Template>
