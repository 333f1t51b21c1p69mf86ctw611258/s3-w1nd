<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_asyncudpsend</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sends a udp packet to the specified destination ip address and port number using the opened async socket. The contents of the packet must be defined in hex, with the string starting with &quot;0x&quot;.  To send the packet containing 4 bytes 01020304, use 0x01020304.

Example:  SA_asyncudpsend 128.100.100.40 2010 0x01020304</Description>
 <InputList>
  <Input>
   <label>Destination IP :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>dest_ip</variable>
  </Input>
  <Input>
   <label>Destination UDP Port :</label>
   <type>1</type>
   <value>162</value>
   <variable>dest_udp_port</variable>
  </Input>
  <Input>
   <label>Content of Packet :</label>
   <type>1</type>
   <value>0x00</value>
   <variable>buffer</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set dest_ip
set dest_udp_port
set buffer
SA_asyncudpsend $dest_ip $dest_udp_port $buffer</script>
</Template>
