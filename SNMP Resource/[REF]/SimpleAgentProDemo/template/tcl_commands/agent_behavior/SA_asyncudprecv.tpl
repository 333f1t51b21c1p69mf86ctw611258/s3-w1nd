<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_asyncudprecv</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command associates the specified callback procedure name with the async socket.  The callback procedure needs to be defined in the init_action section.  It takes one argument which is the received packet.  The received packet is given back as a hex string (0x?..). 

Example:  SA_asyncudprecv callback_procedure</Description>
 <InputList>
  <Input>
   <label>Callback procedure :</label>
   <type>1</type>
   <value>none</value>
   <variable>callback_proc</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set callback_pro;
SA_asyncudprecv $callback_proc</script>
</Template>
