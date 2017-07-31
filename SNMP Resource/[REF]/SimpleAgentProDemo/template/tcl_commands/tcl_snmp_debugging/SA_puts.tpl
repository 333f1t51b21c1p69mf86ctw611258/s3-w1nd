<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_puts</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Outputs the string to the TCL debug file is the file is currently specified and the TCL debug flag is enabled.

Example: SA_puts &quot;got here in the TCL script&quot;</Description>
 <InputList>
  <Input>
   <label>Output String :</label>
   <type>1</type>
   <value>string</value>
   <variable>string</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set string
SA_puts $string</script>
</Template>
