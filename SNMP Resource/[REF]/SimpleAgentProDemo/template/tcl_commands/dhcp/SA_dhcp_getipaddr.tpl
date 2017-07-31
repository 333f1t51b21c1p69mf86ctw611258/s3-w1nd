<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhcp_getipaddr</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command sends a DHCP request to get a new IP address in the modeling file.  The macaddress is mandatory.  Gateway address and additional options string are optional.  The additional options string can be specified using hex strings.   This command returns {newip xid serverip servername filename rebindingtime optionsstr } as a list. This command is only available with the CABLE MODULE option.

Example:  SA_dhcp_getipaddr 0x040d00010203</Description>
 <InputList>
  <Input>
   <label>MAC Address :</label>
   <type>1</type>
   <value>0x010203040506</value>
   <variable>mac_addr</variable>
  </Input>
  <Input>
   <label>Gateway IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>gateway_addr</variable>
  </Input>
  <Input>
   <label>Additional Option :</label>
   <type>1</type>
   <value>none</value>
   <variable>add_opt</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mac_addr
#set gateway_addr
#set add_opt
SA_dhcp_getipaddr $mac_addr #$gateway_addr #$add_opt</script>
</Template>
