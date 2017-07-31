<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_stop_tl1</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Disables support for TL1 for the simulated device. 

Note:
   The TL1 Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable TL1 capability and specify the TL1 modeling file and port number, then you do not need to specifiy the &quot;SA_start_tl1&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <OutputVariables></OutputVariables>
 <script>SA_stop_tl1</script>
</Template>
