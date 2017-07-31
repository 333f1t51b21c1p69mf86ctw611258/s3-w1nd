<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setskipcurvbflag</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command allows you to override the default behavior of the simulated agent which is to include values for all the varbinds present in the request. If for some specific test case, you wanted the agent to only send back values for 4 varbinds, even though 5 varbinds were asked for, you can do this by using this command in the getvalue_action section.

Example:  SA_setskipcurvbflag 1</Description>
 <InputList>
  <Input>
   <label>Current Varbind Flag :</label>
   <type>1</type>
   <value>1</value>
   <variable>flag</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
SA_setskipcurvbflag $flag</script>
</Template>
