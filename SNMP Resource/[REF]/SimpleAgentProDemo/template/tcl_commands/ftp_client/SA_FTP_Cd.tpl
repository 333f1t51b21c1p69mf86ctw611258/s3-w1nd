<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Cd</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Changes the current working directory on the server

Example: SA_FTP_Cd</Description>
 <InputList>
  <Input>
   <label>Directory Path :</label>
   <type>1</type>
   <value>none</value>
   <variable>dir_path</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set dir_path
SA_FTP_Cd -dir $dir_path</script>
</Template>
