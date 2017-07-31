<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settrapmgrs</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the trap recipient managers IP/hostname addresses. The name(s) can include a comma separated list without embedded spaces. This functionality is now extended in Ver 8.0 to also support &quot;trapip/trapport&quot; syntax.  If the trap port is specified, then it will override the one specified in the SA_settrapudpport command.

Example:  SA_settrapmgrs 129.100.100.5,129.100.100.245</Description>
 <InputList>
  <Input>
   <label>Manager IP(s) :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>mgrs</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mgrs
SA_settrapmgrs $mgrs</script>
</Template>
