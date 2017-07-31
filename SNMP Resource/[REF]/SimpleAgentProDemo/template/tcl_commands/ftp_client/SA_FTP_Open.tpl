<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Open</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Opens a connection to the specified FTP server.  If the optional arguments are not specified, the default values are used.  Only one server connection can be open at a time.

Example: SA_FTP_Open -h 192.168.100.40 ?user john ?passwd doe </Description>
 <InputList>
  <Input>
   <label>FTP Server :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>ftp_sever</variable>
  </Input>
  <Input>
   <label>User Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>user</variable>
  </Input>
  <Input>
   <label>Password :</label>
   <type>1</type>
   <value>none</value>
   <variable>passwd</variable>
  </Input>
  <Input>
   <label>Block Size :</label>
   <type>1</type>
   <value>4096</value>
   <variable>size</variable>
  </Input>
  <Input>
   <label>Timeout (secs) :</label>
   <type>1</type>
   <value>120</value>
   <variable>timeout</variable>
  </Input>
  <Input>
   <label>Mode :</label>
   <type>0</type>
   <value>0</value>
   <variable>mode</variable>
   <combomap>
    <mapitem>
     <displayval>active</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>passive</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>21</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ftp_server
set user
set passwd
set size
set timeout
set mode
set port
SA_FTP_Open -h $ftp_server -user $use -passwd $passwd -size $size -timeout $timeout -mode $mode -port $port </script>
</Template>
