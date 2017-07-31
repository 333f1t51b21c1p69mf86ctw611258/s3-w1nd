<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setvar</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Set operation on the specified MIB variables. The results are returned as a list of triplets made up of object identifier, type and value for each of the variables specified.

Example:  SA_setvar {{sysContact.0 OctetString newvalue}}</Description>
 <InputList>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set varbind
SA_setvar { {$varbind} }</script>
</Template>
