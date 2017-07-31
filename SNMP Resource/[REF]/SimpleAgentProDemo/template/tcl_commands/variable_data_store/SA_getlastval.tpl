<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getlastval</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Retrieves the last value returned for that variable. Variables of type randomup, random, sequential etc change their value when retrieved. This command essentially does a get operation on a variable to return the last value returned for it. The results are returned as a list of triplets made up of object identifier, type and value.

Example:   SA_getlastval { sysContact.0 sysLocation.0 }</Description>
 <InputList>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varOid2 </value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set varbind
SA_getlastval { $varbind }</script>
</Template>
