<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_tftpput</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Puts a file on the specified TFTP server.  If the optional arguments are not specified, the default values are used.

Example: SA_tftpput  -h 192.168.100.40 ?local abc.tcl </Description>
 <InputList>
  <Input>
   <label>Server Host Name :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>host</variable>
  </Input>
  <Input>
   <label>Local File Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>local_file</variable>
  </Input>
  <Input>
   <label>Remote File Name :</label>
   <type>1</type>
   <value>local_file</value>
   <variable>remote_file</variable>
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
set local_file
set remote_file
set mode
set retrans
set timeout
SA_tftpput -h $host -local $local_file -remote $remote_file -mode $mode -retransmit $retrans -timeout $timeout 

</script>
</Template>
