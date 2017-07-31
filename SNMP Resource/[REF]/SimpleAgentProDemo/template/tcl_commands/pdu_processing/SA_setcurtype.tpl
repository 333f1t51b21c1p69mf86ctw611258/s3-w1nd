<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setcurtype</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command allows you to override the datatype of the varbind in the response which would normally be the one specified for this instance in the variable file.  So even if sysContat.0 is said to be an OctetString in the variable file, for a certain test case, if you want the agent to return an invalid datatype, you can do this by setting the type to say, Integer.

Example:  SA_setcurtype Integer</Description>
 <InputList>
  <Input>
   <label>Datatype :</label>
   <type>1</type>
   <value>0</value>
   <variable>type</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set type
SA_setcurtype $type</script>
</Template>
