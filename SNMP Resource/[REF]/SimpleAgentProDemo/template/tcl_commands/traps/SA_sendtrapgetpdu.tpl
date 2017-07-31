<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendtrapgetpdu</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Send the specified v1 trap to the associated trap manager IP address of the device. The enterpriseid in oid form, the values of the generic and specific fields along with an optional list of variable bindings. It returns the ASN.1 encoded buffer as a hex octet string. This can be used to populate a last trap sent table if required.

Example: to send a cold start trap :-  SA_sendtrap { 1.3.6.1.4.1.856.1 0 0 }  </Description>
 <InputList>
  <Input>
   <label>Enterprise ID :</label>
   <type>1</type>
   <value>none</value>
   <variable>enterpid</variable>
  </Input>
  <Input>
   <label>Generic Value :</label>
   <type>1</type>
   <value>0</value>
   <variable>generic</variable>
  </Input>
  <Input>
   <label>Specific Value :</label>
   <type>1</type>
   <value>0</value>
   <variable>specific</variable>
  </Input>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set enterpid
set generic
set specific
set varbind
SA_sendtrapgetpdu { $enterpid  $generic  $specific {$varbind}}</script>
</Template>
