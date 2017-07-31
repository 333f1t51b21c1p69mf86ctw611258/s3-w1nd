<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_setdelay</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to sleep for the specified time before replying to telnet commands.

Example:SA_telnet_setdelay 500

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Miliseconds delay</label>
   <type>1</type>
   <value>0</value>
   <variable>msecs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set msecs
SA_telnet_setdelay $msecs</script>
</Template>
