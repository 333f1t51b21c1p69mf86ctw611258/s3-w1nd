<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendv3informwdiscovery</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Send the specified v3 inform request to the associated inform manager specified in the SA_setv3informmgrinfo call. Will do discovery if required and wait for response.

Example: SA_sendv3informwdiscovery {1.3.6.1.4.1.856.1.1 {ifOperStatus.1 Integer 1}} will send a v3 inform request with the first varbind being sysUpTime.0, the next one being snmpTrapOid.0 with its value being 1.3.6.1.4.1.856.1.1 and the third varbind being ifOperStatus.1.</Description>
 <InputList>
  <Input>
   <label>Trap ID :</label>
   <type>1</type>
   <value>0</value>
   <variable>trapid</variable>
  </Input>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set trapid
set varbind
SA_sendv3informwdiscovery { $trapid { $varbind } }
</script>
</Template>
