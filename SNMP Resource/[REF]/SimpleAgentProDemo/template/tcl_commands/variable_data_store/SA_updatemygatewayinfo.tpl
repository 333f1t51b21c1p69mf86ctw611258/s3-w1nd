<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_updatemygatewayinfo</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command creates a new variable file for a gateway based on the devices currently running on the machine. All arguments are optional. The first option specifies the hostid component to be used in the router?s IP address derivation for a new subnet.  The deault used is 254.  So if there simulated devices in a new subnet, say 192.168.10.0, the router interface would be set to 192.168.10.254 if that is available.   If no variable file is specified, the current device s variable file is overwritten.  If no interface string is specified, the currently used interface string is used.

Example:   SA_updatemygatewayinfo</Description>
 <InputList>
  <Input>
   <label>Host ID :</label>
   <type>1</type>
   <value>none</value>
   <variable>hostid</variable>
  </Input>
  <Input>
   <label>Variable File :</label>
   <type>1</type>
   <value>abc.var</value>
   <variable>varfile</variable>
  </Input>
  <Input>
   <label>Interface :</label>
   <type>1</type>
   <value>none</value>
   <variable>interface</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>#set hostid
#set varfile
#set interface
SA_updatemygatewayinfo #$hostid #$varfile #$interface</script>
</Template>
