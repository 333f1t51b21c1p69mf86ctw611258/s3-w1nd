<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_asyncudpopen</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command opens up a UDP socket that is bound to the specified port. 

Example:  SA_asyncudpopen 2456</Description>
 <InputList>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>2010</value>
   <variable>port_num</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set port_num
SA_asyncudpopen $port_num</script>
</Template>
