<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_disablerow</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Disables a row from a table that allows dynamic row creation. This just marks the row as inactive in memory but does not remove it. This makes it faster to add and remove the same rows. The column id is used to identify the table, and the instance component is used to identify the row in the table.

Example:  SA_disablerow ipNetToMediaIfIndex.1.128.100.100.151</Description>
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
SA_disablerow $colinst</script>
</Template>
