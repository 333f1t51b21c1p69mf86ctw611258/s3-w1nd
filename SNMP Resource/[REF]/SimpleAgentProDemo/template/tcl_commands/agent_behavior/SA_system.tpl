<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_system</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This makes a system call to execute the specified argument..

Example: SA_system &quot;myexecutable argument1 argument2&quot;</Description>
 <InputList>
  <Input>
   <label>Executable Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>args</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set args
SA_system $args</script>
</Template>
