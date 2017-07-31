<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhcp_rebindipaddr</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command rebinds the DHCP address retrieved in a prior SA_dhcp_getipaddr call. This command is only available with the CABLE MODULE option.

Example:  SA_dhcp_rebindipaddr 0x040d00010203 192.168.100.2 1234 192.168.10.1</Description>
 <InputList>
  <Input>
   <label>MAC Address :</label>
   <type>1</type>
   <value>0x010203040506</value>
   <variable>mac_addr</variable>
  </Input>
  <Input>
   <label>IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>newip</variable>
  </Input>
  <Input>
   <label>ID :</label>
   <type>1</type>
   <value>0</value>
   <variable>xid</variable>
  </Input>
  <Input>
   <label>Server IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>servip</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mac_addr
set newip
set xid
set servip
SA_dhcp_rebindipaddr mac_addr newip xid serverip</script>
</Template>
