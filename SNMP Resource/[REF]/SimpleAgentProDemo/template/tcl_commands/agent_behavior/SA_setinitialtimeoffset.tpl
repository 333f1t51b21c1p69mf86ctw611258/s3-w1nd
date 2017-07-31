<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setinitialtimeoffset</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This causes the current initial time associated with a device to be decremented by the specified value.  Changing this value will affect all internally computed timestamps in traps and TimeTicks values..

Example: SA_setinitialtimeoffset 5000</Description>
 <InputList>
  <Input>
   <label>TimeoffSet Value :</label>
   <type>1</type>
   <value>0</value>
   <variable>timeoff</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set timeoff
SA_setinitialtimeoffset $timeoff</script>
</Template>
