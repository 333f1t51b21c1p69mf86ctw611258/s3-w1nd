<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setrequestid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command allows you to override the default behavior of the simulated agent which is to echo the request id of the incoming request.  If for some specific test case, you wanted the agent to send back incorrect requestids, , you can do this by using this command.

Example:  SA_setrequestid 5555</Description>
 <InputList>
  <Input>
   <label>Request ID :</label>
   <type>1</type>
   <value>0</value>
   <variable>id</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set id
SA_setrequestid $id</script>
</Template>
