<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setsyslogudpport</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the UDP port on the syslog recipient managers to which the syslogs will be sent. By default this is set to port 514. This port number is used for all the syslog managers.

Example:  SA_setsyslogudpport  2061</Description>
 <InputList>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>514</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set port
SA_setsyslogudpport $port</script>
</Template>
