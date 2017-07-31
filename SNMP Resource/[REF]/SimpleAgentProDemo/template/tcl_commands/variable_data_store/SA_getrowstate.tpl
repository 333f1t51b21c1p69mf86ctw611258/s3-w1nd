<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getrowstate</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Returns the current state of a row [Row Enabled/Row Disabled].  The  column id is used to identify the table, and the instance component is used to identify the row in the table.

Example:  SA_getrowstate ipNetToMediaIfIndex.1.128.100.100.151</Description>
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
SA_getrowstate $colinst</script>
</Template>
