<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settrapreqid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Specifies the starting value of the trap request id used in subsequent trap emissions.  The actual number is used will be one more than the value specified.

Example: SA_settrapreqid  54</Description>
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
SA_settrapreqid $id</script>
</Template>
