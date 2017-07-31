<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_gnextvar</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Getnext operation on the specified MIB variables. The results are returned as a list of triplets made up of object identifier, type and value for each of the variables specified.

Example:  SA_gnextvar { sysContact sysLocation }</Description>
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
SA_gnextvar { $varlist }</script>
</Template>
