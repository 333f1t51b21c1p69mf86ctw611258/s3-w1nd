<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setcurvalue</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the current value to the specified value. This can be used to override the value returned during get/getnext operations.   Setting it to special strings like SA_NOSUCHOBJECT, SA_NOSUCHINSTANCE, SA_ENDOFMIBVIEW, causes these error values to be returned for SNMPv2 packets.

Example:  SA_setcurvalue  pppp</Description>
 <InputList>
  <Input>
   <label>New Value  :</label>
   <type>1</type>
   <value>none</value>
   <variable>newvalue</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set newvalue
SA_setcurvalue $newvalue</script>
</Template>
