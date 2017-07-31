<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_gettimefromTODServer</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sends a TOD request to the specified TOD server.  todport and timeout_val are optional arguments.  If they are not specified, the todport is set to 37 and timeout is set to 1 sec.

Example:SA_gettimeFromTODServer 192.168.100.50</Description>
 <InputList>
  <Input>
   <label>IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>ip</variable>
  </Input>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>37</value>
   <variable>port</variable>
  </Input>
  <Input>
   <label>Timeout (secs) :</label>
   <type>1</type>
   <value>1</value>
   <variable>timeout</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ip
set port
set timeout
SA_gettimefromTODServer  $ip $port $timeout</script>
</Template>
