<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_seteoltype</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to accept just LF as a end of line character instead of the default [CRLF].  For some telnet applications, based on how they are configured, it might be necessary to allow just LF to terminate commands.

Example:SA_telnet_seteoltype LF

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>EOL Type</label>
   <type>1</type>
   <value>CRLF</value>
   <variable>type</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set type
SA_telnet_seteoltype $type</script>
</Template>
