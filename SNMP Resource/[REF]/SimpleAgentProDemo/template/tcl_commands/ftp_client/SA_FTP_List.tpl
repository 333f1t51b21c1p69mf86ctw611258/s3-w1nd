<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_List</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Causes a list to be sent from the server to user site.  A null argument implies the current directory listing.

Example: SA_FTP_List</Description>
 <InputList>
  <Input>
   <label>Directory :</label>
   <type>1</type>
   <value>NULL</value>
   <variable>dir</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set dir
SA_FTP_List -dir $dir</script>
</Template>
