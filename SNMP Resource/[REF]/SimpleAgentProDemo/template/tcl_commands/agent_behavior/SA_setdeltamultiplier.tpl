<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setdeltamultiplier</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the delta multiplier used globally by the device for all variables. The value is specified in 1/100th increments. By default its value is 100, which results in any delta computed multiplied by a value of 1. Setting it to 1000 would cause all the counters to speed up 10 times as fast as before, while still exhibiting the randomup style behavior. Setting it to 0 will cause all randomup values to be effectively made into fixed.

 Example: SA_setdeltamultiplier 5000</Description>
 <InputList>
  <Input>
   <label>Delta Value :</label>
   <type>1</type>
   <value>0</value>
   <variable>new_value</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set new_value
SA_setdeltamultiplier $new_value</script>
</Template>
