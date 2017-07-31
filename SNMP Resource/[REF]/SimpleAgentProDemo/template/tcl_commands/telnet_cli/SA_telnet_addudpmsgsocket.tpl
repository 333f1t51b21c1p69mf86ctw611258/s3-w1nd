<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_addudpmsgsocket</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to open up a UDP socket for that port.  If multiple sessions are established, and the port specified is N, then the N+1 port will be opened by the second session, and N+2 port will be opened by the third session and so on.  When a message is received on this port, it is sent to telnet tcl interpretor for evaluation.  This allows tcl scripts to be evaluated on a connection oriented session such as telnet.

Example:SA_telnet_addudpmsgsocket 2456

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Port Number</label>
   <type>1</type>
   <value>0</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set port
SA_telnet_addudpmsgsocket $port</script>
</Template>
