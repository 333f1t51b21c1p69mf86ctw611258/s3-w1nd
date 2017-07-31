<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settrapudpport</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the UDP port on the trap recipient managers to which the traps will be sent. By default this is set to port 162. This port number is used for all the trap managers.

Example:  SA_settrapudpport  2061</Description>
 <InputList>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>162</value>
   <variable>portnum</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set portnum
SA_settrapudpport $portnum</script>
</Template>
