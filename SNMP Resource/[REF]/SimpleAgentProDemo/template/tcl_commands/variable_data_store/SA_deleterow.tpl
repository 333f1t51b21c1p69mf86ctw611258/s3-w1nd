<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_deleterow</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Deletes a row from a table that allows dynamic row creation. The column id is used to identify the table and the instance component is used to delete all the related columnar instances from the other columns that make up the table.

Example:  SA_deleterow ipNetToMediaIfIndex.1.128.100.100.151</Description>
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
SA_deleterow $colinst</script>
</Template>
