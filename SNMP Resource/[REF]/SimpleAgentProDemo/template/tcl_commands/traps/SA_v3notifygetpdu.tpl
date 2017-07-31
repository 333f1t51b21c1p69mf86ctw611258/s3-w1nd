<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_v3notifygetpdu</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Returns an octet string of the encoded trap buffer that can be used later in a SA_sendtrappdu call.

Example: SA_sendv3notify {1.3.6.1.4.1.856.1.1 {ifOperStatus.1 Integer 1}} will return an encoded PDU buffer for a v3 notification with the first varbind being sysUpTime.0, the next one being snmpTrapOid.0 with its value being 1.3.6.1.4.1.856.1.1 and the third varbind being ifOperStatus.1.  Does not do discovery.</Description>
 <InputList>
  <Input>
   <label>Trap ID :</label>
   <type>1</type>
   <value>0</value>
   <variable>trapid</variable>
  </Input>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set trapid
set varbind
SA_v3notifygetpdu { $trapid { $varbind } }</script>
</Template>
