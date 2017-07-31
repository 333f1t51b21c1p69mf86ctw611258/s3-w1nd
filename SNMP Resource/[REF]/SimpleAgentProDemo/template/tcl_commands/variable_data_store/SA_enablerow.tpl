<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_enablerow</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Enables a previously disabled row from a table that allows dynamic row creation. This just marks the row as active in memory but does not create it. This makes it faster to add and remove the same rows. The column id is used to identify the table, and the instance component is used to identify the row in the table.

Example:  SA_enablerow ipNetToMediaIfIndex.1.128.100.100.151</Description>
 <InputList>
  <Input>
   <label>Column Instance :</label>
   <type>1</type>
   <value>none</value>
   <variable>colinst</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set colinst
SA_enablerow $colinst</script>
</Template>
