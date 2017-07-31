<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_setloginuser</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the login user name string that is to be expected by the telnet.  This can include multiple names separated by a comma.

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>User Name</label>
   <type>1</type>
   <value>none</value>
   <variable>string</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set string
SA_telnet_setloginuser $string</script>
</Template>
