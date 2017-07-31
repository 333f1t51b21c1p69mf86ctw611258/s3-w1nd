<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_seterrorstatus</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This causes the response PDU to be generated with the specified SNMP error status for the currently processed variable binding.   Setting the error status to a special value of 9999 causes the PDU to be discarded and no response sent.

 Example: SA_seterrorstatus 1</Description>
 <InputList>
  <Input>
   <label>Error Status Value :</label>
   <type>1</type>
   <value>1</value>
   <variable>err_status</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set err_status
SA_seterrorstatus $err_status</script>
</Template>
