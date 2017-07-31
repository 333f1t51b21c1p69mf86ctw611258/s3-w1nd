<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setmaxnumvbs</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the maximum number of varbinds that can be processed by the agent, after which it will generate a TOO_BIG error. If the value is 0, (default), the effect of this variable is ignored and the agent will respond to as many variable bindings as can fit into the MTU size of the response packet. 

Example:  SA_setmaxnumvbs 10</Description>
 <InputList>
  <Input>
   <label>Max number of varbinds :</label>
   <type>1</type>
   <value>0</value>
   <variable>num_var</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set num_var
SA_setmaxnumvbs $num_var</script>
</Template>
