<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_getmodfile</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to return the full name of the currently used telnet modeling file.

Example:set mytfile [SA_telnet_getmodfile]

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <OutputVariables></OutputVariables>
 <script>SA_telnet_getmodfile</script>
</Template>
