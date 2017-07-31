<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_tftpget</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Gets a file from the specified TFTP server.  If the optional arguments are not specified, the default values are used.

Example: SA_tftpget  -h 192.168.100.40 ?remote abc.tcl </Description>
 <InputList>
  <Input>
   <label>Server Host Name :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>host</variable>
  </Input>
  <Input>
   <label>Remote File Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>remote_file</variable>
  </Input>
  <Input>
   <label>Local File Name :</label>
   <type>1</type>
   <value>remote_file</value>
   <variable>local_file</variable>
  </Input>
  <Input>
   <label>Mode :</label>
   <type>0</type>
   <value>0</value>
   <variable>mode</variable>
   <combomap>
    <mapitem>
     <displayval>netascii</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>octet</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Retransmission Time :</label>
   <type>1</type>
   <value>5</value>
   <variable>retrans</variable>
  </Input>
  <Input>
   <label>Timeout (secs) :</label>
   <type>1</type>
   <value>25</value>
   <variable>timeout</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set host
set remote_file
set local_file
set mode
set retrans
set timeout
SA_tftpget -h $host -remote $remote_file -local $local_file -mode $mode -retransmit $retrans -timeout $timeout 
</script>
</Template>
