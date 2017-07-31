<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_setloginnumretries</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the login retry count.  If the invalid logins exceed this count, the session is terminated.  By default its value is set to 3.

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.
</Description>
 <InputList>
  <Input>
   <label>Number of Retries</label>
   <type>1</type>
   <value>3</value>
   <variable>count</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set count
SA_telnet_setloginnumretries $count</script>
</Template>
