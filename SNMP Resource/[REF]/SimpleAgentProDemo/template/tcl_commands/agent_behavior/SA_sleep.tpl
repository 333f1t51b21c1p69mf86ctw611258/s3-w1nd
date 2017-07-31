<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sleep</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Makes the device interpreter wait for the specified milliseconds before executing the next Tcl command.  While sleeping, no SNMP requests will get processed.

Example: SA_sleep 2000</Description>
 <InputList>
  <Input>
   <label>Sleep (milisecs) :</label>
   <type>1</type>
   <value>0</value>
   <variable>mili_secs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mili_secs
SA_sleep $mili_secs</script>
</Template>
