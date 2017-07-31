<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getvar</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Get operation on the specified MIB variables. The results are returned as a list of triplets made up of object identifier, type and value for each of the variables specified.

Example:   SA_getvar { sysContact.0 sysLocation.0 }</Description>
 <InputList>
  <Input>
   <label>Variables List :</label>
   <type>1</type>
   <value>none</value>
   <variable>varlist</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set varlist
SA_getvar  { $varlist }</script>
</Template>
