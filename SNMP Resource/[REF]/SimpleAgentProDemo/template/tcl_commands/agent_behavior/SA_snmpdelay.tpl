<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_snmpdelay</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the SNMP response delay to the new value specified. The value is in milliseconds. A special value of 9999 makes the Agent stop responding to SNMP requests.

Example: SA_snmpdelay 1000</Description>
 <InputList>
  <Input>
   <label>Delay (milisecs) :</label>
   <type>1</type>
   <value>1000</value>
   <variable>mili_secs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mili_secs
SA_snmpdelay $mili_secs</script>
</Template>
