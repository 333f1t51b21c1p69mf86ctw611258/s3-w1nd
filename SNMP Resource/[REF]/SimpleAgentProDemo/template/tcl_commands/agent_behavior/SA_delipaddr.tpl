<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_delipaddr</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command deletes a previously added ip address through the SA_addipaddr command.   This command is only available in the unrestricted version.

Example: SA_delipaddr 192.168.100.1</Description>
 <InputList>
  <Input>
   <label>IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>ip</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ip
SA_delipaddr $ip</script>
</Template>
