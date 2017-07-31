<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setpacketdroptimeout</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the maximum number of seconds a request could wait in the request queue after which it would get discarded without processing.  By default the time is set to zero(0) which means that there is no check done.  However if set to a non zero value, requests waiting longer than the specified seconds will be discarded prior to processing. 

Example:  SA_setpacketdroptimeout 10</Description>
 <InputList>
  <Input>
   <label>Timout Miliseconds :</label>
   <type>1</type>
   <value>0</value>
   <variable>mili_secs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mili_secs
SA_setpacketdroptimeout $mili_secs</script>
</Template>
