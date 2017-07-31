<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setvaltype</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Set operation to change the value type associated with a variable. Using this, you can change the value type of ifOctets.1 from randomup(1000, 100) to randomup(4000, 1000) and thus cause the counter to increment more rapidly.

Please note that this command expects the value type to be OctetString even if the value type of the variable changed is something else like Integer. This is because what is being sent is a string &quot;randomup(1000, 100)&quot; and not a number like 1052.

Example: SA_setvaltype {{ifOperStatus.1 OctetString fixed(2)}}</Description>
 <InputList>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>none</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set varbind
SA_setvaltype { {$varbind} }</script>
</Template>
