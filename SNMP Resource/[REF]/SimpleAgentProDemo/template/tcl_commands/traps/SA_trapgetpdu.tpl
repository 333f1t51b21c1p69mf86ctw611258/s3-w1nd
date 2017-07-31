<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_trapgetpdu</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Returns an octet string of the encoded trap buffer that can be used later in a SA_sendtrapdu call.   Since most of the time is spent in parsing the arguments and encoding the pdu, this work could be done beforehand.  Please note however that the timestamps inside the pdu will reflect the time the packet was built, not when it was sent out. The enterpriseid in oid form, the values of the generic and specific fields along with an optional list of variable bindings.

Example: to get a pdu for a cold start trap :-  SA_trapgetpdu { 1.3.6.1.4.1.856.1 0 0 }  </Description>
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
SA_trapgetpdu { $enterpid  $generic  $specific { $varbind } }</script>
</Template>
