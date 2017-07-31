<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_updatetimerdelay</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This causes the time action interval in the modeling file associated with this device to be updated to the new delay interval.   The delay is assumed to be specified in seconds.

Example: SA_updatetimerdelay 20</Description>
 <InputList>
  <Input>
   <label>Delay (milisecs) :</label>
   <type>1</type>
   <value>0</value>
   <variable>mili_secs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mili_secs
SA_updatetimerdelay $mili_secs</script>
</Template>
