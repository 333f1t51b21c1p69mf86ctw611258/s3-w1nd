<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_getsnmpval</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>A shorthand way to get the value of the snmp variable defined by oid1.

Example:set val1 [SA_telnet_getsnmpval { ifInOctects.1 }]

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>OID</label>
   <type>1</type>
   <value>none</value>
   <variable>oid</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set oid
SA_telnet_getsnmpval { $oid1 }</script>
</Template>
