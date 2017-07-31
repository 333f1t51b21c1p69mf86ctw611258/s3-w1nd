<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_start_telnet</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Enables a telnet server to service requests for the simulated device.  The telnet_cmd_file file is mandatory.  It tells the SimpleAgentPro how to respond to telnet commands typed in by the user.  The telnet port is optional.  If no port is specified the default port (23) is used.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the &quot;SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Telnet Command File</label>
   <type>1</type>
   <value>none</value>
   <variable>cmd_file</variable>
  </Input>
  <Input>
   <label>Telnet Port</label>
   <type>1</type>
   <value>23</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set cmd_file
set port
SA_start_telnet  $cmd_file $port</script>
</Template>
