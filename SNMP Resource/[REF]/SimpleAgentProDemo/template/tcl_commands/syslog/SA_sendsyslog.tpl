<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendsyslog</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Send the specified syslog message to the associated syslog manager IP address of the device.

Example: SA_sendsyslog &quot;10/22/2002:18/31/15:SYS-5-MOD_INSERT:Module 5&quot;</Description>
 <InputList>
  <Input>
   <label>Syslog Message :</label>
   <type>1</type>
   <value>none</value>
   <variable>syslog_msg</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set syslog_msg
SA_sendsyslog $syslog_msg</script>
</Template>
