<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_deletetable</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Deletes all rows from a table that allows dynamic row creation. The column id is used to identify the table. Any column from the table is acceptable.

Example: SA_deletetable ipNetToMediaIfIndex</Description>
 <InputList>
  <Input>
   <label>Column :</label>
   <type>1</type>
   <value>none</value>
   <variable>col</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set col
SA_deletetable $col</script>
</Template>
