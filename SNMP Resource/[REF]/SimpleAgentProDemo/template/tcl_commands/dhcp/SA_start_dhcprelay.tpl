<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_start_dhcprelay</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command starts a DHCP relay service on the specified IP address, and port and packets received on the port are broadcast on the local subnet.  This command is only available with the CABLE MODULE option.

Example:  SA_start_dhcprelay 192.168.100.10  68 192.168.10.1</Description>
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
   <value>162</value>
   <variable>port</variable>
  </Input>
  <Input>
   <label>Local Subnet :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>local_subnet</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ip
set port
set local_subnet
SA_start_dhcprelay $ip $port $local_subnet</script>
</Template>
