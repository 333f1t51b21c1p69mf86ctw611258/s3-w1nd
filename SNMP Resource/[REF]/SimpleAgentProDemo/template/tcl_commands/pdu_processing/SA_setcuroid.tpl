<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setcuroid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command allows you to override the object identifier of the varbind in the response which would normally be the one specified for this instance in the variable file.  So even if someone has done a SNMP GET on sysContat.0, rather than returning 1.3.6.1.2.1.1.4.0,  for a certain test case, if you want the agent to return an invalid object identifier, you can do this by setting the current oid to 1.3.6.1.2.999.999.999.999.0  Using this command in the check_set_action can also allow you to change the oid in the set response.

Example:  SA_setcuroid  1.3.6.1.2.99.99.99.0 </Description>
 <InputList>
  <Input>
   <label>OID :</label>
   <type>1</type>
   <value>0</value>
   <variable>oid</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set oid
SA_setcuroid $oid</script>
</Template>
