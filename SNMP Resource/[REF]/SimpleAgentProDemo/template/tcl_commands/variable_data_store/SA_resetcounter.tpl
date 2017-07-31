<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_resetcounter</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Resets the value of the variable of type counter. GetRequests to this variable will see it value start once again from zero. This works for variables with an associated value type of random , randomup or clock.

Example: SA_resetcounter ifInOctets.1</Description>
 <InputList>
  <Input>
   <label>Variable :</label>
   <type>1</type>
   <value>none</value>
   <variable>myvar</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set myvar
SA_resetcounter $myvar</script>
</Template>
