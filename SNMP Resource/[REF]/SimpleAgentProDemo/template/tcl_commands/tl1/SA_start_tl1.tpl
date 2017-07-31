<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_start_tl1</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Enables a TL1 server to service requests for the simulated device.  The tl1_cmd_file file is mandatory.  It tells the SimpleAgentPro how to respond to telnet commands typed in by the user.  The telnet port is also mandatory.  

The tl1_cmd_file runs in a separate tcl interpretor that has both snmp and telnet command extensions available.

Note:
   The TL1 Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable TL1 capability and specify the TL1 modeling file and port number, then you do not need to specifiy the &quot;SA_start_tl1&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>TL1 Command File :</label>
   <type>1</type>
   <value>abc.tl1</value>
   <variable>cmd_file</variable>
  </Input>
  <Input>
   <label>TL1 Port Number :</label>
   <type>1</type>
   <value>123</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set cmd_file
set port
SA_start_tl1  $cmd_file $port</script>
</Template>
