<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Rename</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Causes the file specified in from argument to be renamed at the server site.

Example: SA_FTP_Rename ?from abc.tcl ?to pqr.tc</Description>
 <InputList>
  <Input>
   <label>From :</label>
   <type>1</type>
   <value>none</value>
   <variable>from</variable>
  </Input>
  <Input>
   <label>To :</label>
   <type>1</type>
   <value>none</value>
   <variable>to</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set from
set to
SA_FTP_Rename -from $from -to $to</script>
</Template>
