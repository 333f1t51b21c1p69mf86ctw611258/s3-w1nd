<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setafterresponseid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the value of the response_id_flag so that the SAPro can then interpret the %after_snmp_response related tcl scripts. The SAPro automatically resets it after this tcl script is interpreted, so that it is ready for processing the next SNMP request.</Description>
 <InputList>
  <Input>
   <label>Response ID :</label>
   <type>1</type>
   <value>none</value>
   <variable>id</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set id
SA_setafterresponseid  $id</script>
</Template>
