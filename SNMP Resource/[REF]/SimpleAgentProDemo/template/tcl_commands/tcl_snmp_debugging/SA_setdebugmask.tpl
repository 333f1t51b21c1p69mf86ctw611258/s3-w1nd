<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setdebugmask</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the debug mask level.  Used in conjunction with SA_debugputs.

Example: SA_setdebugmask 0x03</Description>
 <InputList>
  <Input>
   <label>Mask Value :</label>
   <type>1</type>
   <value>0x00</value>
   <variable>maskvalue</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set maskvalue
SA_setdebugmask $maskvalue</script>
</Template>
