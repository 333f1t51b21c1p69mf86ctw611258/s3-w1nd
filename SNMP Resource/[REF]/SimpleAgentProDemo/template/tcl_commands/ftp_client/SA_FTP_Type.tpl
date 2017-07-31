<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_FTP_Type</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the file transfer type to either ascii or binary.

Example: SA_FTP_Type ?type ascii</Description>
 <InputList>
  <Input>
   <label>File Transfer Type :</label>
   <type>0</type>
   <value>0</value>
   <variable>type</variable>
   <combomap>
    <mapitem>
     <displayval>ascii</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>binary</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set type
SA_FTP_Type -type $type</script>
</Template>
