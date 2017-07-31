<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setcurstat</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the current status to the specified new value. A value of 1 indicates that the operation is OK, and a value of 0 indicates that the operation is not OK. This is used during set validation.

Example:  SA_setcurstat 0</Description>
 <InputList>
  <Input>
   <label>New Status Value :</label>
   <type>1</type>
   <value>1</value>
   <variable>newvalue</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set newvalue
SA_setcurstat $newvalue</script>
</Template>
