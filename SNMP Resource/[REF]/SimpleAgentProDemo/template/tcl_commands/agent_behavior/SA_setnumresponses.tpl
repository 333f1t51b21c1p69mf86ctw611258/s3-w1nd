<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setnumresponses</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command allows you to override the default behavior of the simulated agent to generate one response per request.  If for some specific test case, you wanted the agent to transmit multiple responses, you can do this by using this command.

Example:  SA_setnumresponses 4</Description>
 <InputList>
  <Input>
   <label>Number of Responses :</label>
   <type>1</type>
   <value>1</value>
   <variable>num_resp</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set num_resp
SA_setnumresponses $num_resp</script>
</Template>
