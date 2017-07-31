<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_mapoid2label</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Maps the object identifier specified to an object descriptor based on the information present in the compiled MIB file associated with the device.

Example: SA_mapoid2label 1.3.6.1.2.1.1.1</Description>
 <InputList>
  <Input>
   <label>OID String :</label>
   <type>1</type>
   <value>none</value>
   <variable>oidstring</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set oidstring
SA_mapoid2label  $oidstring</script>
</Template>
