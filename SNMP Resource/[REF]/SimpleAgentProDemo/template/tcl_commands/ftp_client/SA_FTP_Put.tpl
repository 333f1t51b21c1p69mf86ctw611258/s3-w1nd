<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Put</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Puts the specified local file in the current working directory on the server.  If the remote file name is not specified, the name of the local file is used..

Example: SA_FTP_Put ?local myFile</Description>
 <InputList>
  <Input>
   <label>Local File :</label>
   <type>1</type>
   <value>none</value>
   <variable>local_file</variable>
  </Input>
  <Input>
   <label>Remote File :</label>
   <type>1</type>
   <value>none</value>
   <variable>remote_file</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set local_file
set remote_file
SA_FTP_Put -local $local_file -remote $remote_file</script>
</Template>
