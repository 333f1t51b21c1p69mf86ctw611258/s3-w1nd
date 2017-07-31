<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_updaterowinstance</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Updates the instance component of integer based tables to save a deletion and a subsequent addition.

Example:  SA_updaterowinstance e1Col1.5  e1Col1.6</Description>
 <InputList>
  <Input>
   <label>Column Old Instance :</label>
   <type>1</type>
   <value>none</value>
   <variable>cololdinst</variable>
  </Input>
  <Input>
   <label>Column New Instance :</label>
   <type>1</type>
   <value>none</value>
   <variable>colnewinst</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set cololdinst 
set colnewinst
SA_updaterowinstance  $cololdinst  $colnewinst</script>
</Template>
