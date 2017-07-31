<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Get</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Gets the specified remote file in the current working directory on the server.  If the remote file name is not specified, the name of the local file is used..

Example: SA_FTP_Get -remote myFile</Description>
 <InputList>
  <Input>
   <label>Remote File :</label>
   <type>1</type>
   <value>none</value>
   <variable>remote_file</variable>
  </Input>
  <Input>
   <label>Local File :</label>
   <type>1</type>
   <value>none</value>
   <variable>local_file</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set remote_file
set local_file
SA_FTP_Get -remote $remote_file -local $local_file</script>
</Template>
