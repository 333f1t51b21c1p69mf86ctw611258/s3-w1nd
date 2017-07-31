<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_debugputs</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>If the mask_bit when logically &quot;and&quot;ed with the debug mask is non zero, the string specified is put into the tcldbebugfile if present.  This allows you to optionally turn on/off debug tracing information in your code.

Example: SA_debugputs 0x01 &quot;got here in the TCL script&quot;</Description>
 <InputList>
  <Input>
   <label>Mask bit :</label>
   <type>1</type>
   <value>0x00</value>
   <variable>mask_bit</variable>
  </Input>
  <Input>
   <label>Output String :</label>
   <type>1</type>
   <value>string</value>
   <variable>string</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mask_bit
set string
SA_debugputs $mask_bit $string</script>
</Template>
