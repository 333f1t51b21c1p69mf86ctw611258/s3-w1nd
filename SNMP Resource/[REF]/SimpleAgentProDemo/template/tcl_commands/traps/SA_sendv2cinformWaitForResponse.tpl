<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendv2cinformWaitForResponse</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Send the specified v2c inform request to the associated trap manager IP address of the device and wait for the specified timeout_secs to receive the response.  If no response is received, it will automatically retransmit the specified number of retries.  Please note that this call is blocking.  If the manager does not send a response and the timeout was 2 secs, and the number of retries is 3, the device thread will be blocked for 6 secs for each of the trap manager specified.

Example: SA_sendv2cinformWaitForResponse {2 3 1.3.6.1.4.1.856.1.1 {ifOperStatus.1 Integer 1}} will send a v2c inform request with the first varbind being sysUpTime.0, the next one being snmpTrapOid.0 with its value being 1.3.6.1.4.1.856.1.1 and the third varbind being ifOperStatus.1.  It will wait for 2 secs for the response and retry 3 times.</Description>
 <InputList>
  <Input>
   <label>Timeout (secs) :</label>
   <type>1</type>
   <value>0</value>
   <variable>time_out</variable>
  </Input>
  <Input>
   <label>Number of Retries :</label>
   <type>1</type>
   <value>1</value>
   <variable>retires_num</variable>
  </Input>
  <Input>
   <label>Trap ID :</label>
   <type>1</type>
   <value>0</value>
   <variable>trapId</variable>
  </Input>
  <Input>
   <label>List of Varbind :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbind</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set time_out
set retries_num
set trapId
set varbind
SA_sendv2cinformWaitForResponse { $time_out $retries_num $trapId { $varbind}}</script>
</Template>
