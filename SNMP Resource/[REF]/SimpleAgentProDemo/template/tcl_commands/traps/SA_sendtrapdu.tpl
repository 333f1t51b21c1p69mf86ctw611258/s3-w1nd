<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendtrapdu</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sends the encoded buffer got previously to the list of trap managers.

Example: set mybuf [SA_trapgetpdu { 1.2.3 0 0 }]
                SA_sendtrapdu $mybuf</Description>
 <InputList>
  <Input>
   <label>PDU Buffer :</label>
   <type>1</type>
   <value>0</value>
   <variable>pdu_buffer</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mybuf
SA_sendtrapdu $mybuf</script>
</Template>
