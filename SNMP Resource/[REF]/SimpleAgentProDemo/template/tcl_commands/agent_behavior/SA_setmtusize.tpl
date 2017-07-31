<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setmtusize</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the MTU size associated with the device to the newly specified value.

Example:  SA_setmtusize  1400</Description>
 <InputList>
  <Input>
   <label>MTU Size :</label>
   <type>1</type>
   <value>1500</value>
   <variable>size</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set size
SA_setmtusize $size</script>
</Template>
