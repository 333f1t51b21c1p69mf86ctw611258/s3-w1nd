<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setsyslogmgrs</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the syslog recipient managers IP/hostname addresses. The name(s) can include a comma separated list without embedded spaces.

Example:  SA_sesyslogmgrs 129.100.100.5,129.100.100.245</Description>
 <InputList>
  <Input>
   <label>Syslog Manger Names :</label>
   <type>1</type>
   <value>none</value>
   <variable>mgr_names</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mgr_names
SA_setsyslogmgrs $mgr_names</script>
</Template>
