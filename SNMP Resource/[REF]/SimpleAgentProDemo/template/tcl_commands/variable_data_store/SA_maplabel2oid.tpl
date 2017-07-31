<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_maplabel2oid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Maps the object descriptor specified to an object identifier based on the information present in the compiled MIB file associated with the device.

Example: SA_maplabel2oid sysDescr</Description>
 <InputList>
  <Input>
   <label>Object Descriptor :</label>
   <type>1</type>
   <value>none</value>
   <variable>label</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set label
SA_maplabel2oid  $label</script>
</Template>
