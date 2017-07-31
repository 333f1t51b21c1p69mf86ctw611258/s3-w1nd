<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settrapownip</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command specifies the IP address to use when emitting traps, when supporting multiple addresses using the SA_addipaddr command.  By default traps get sent out using the device?s primary IP address.   This command is only available in the unrestricted version.

Example: SA_settrapownip 192.168.100.1</Description>
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
SA_settrapownip $ip</script>
</Template>
