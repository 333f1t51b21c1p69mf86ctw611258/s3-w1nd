<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Delete</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Causes the file to be deleted on the server..

Example: SA_FTP_Delete ?file abc.tcl</Description>
 <InputList>
  <Input>
   <label>Delete File :</label>
   <type>1</type>
   <value>none</value>
   <variable>file</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set file
SA_FTP_Delete -file $file</script>
</Template>
