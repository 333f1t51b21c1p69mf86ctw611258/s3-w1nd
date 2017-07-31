<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>Send_ColdStart_Trap</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>example of initial action that causes a cold start trap to be emitted to the associated trap manager
</Description>
 <InputList>
  <Input>
   <label>Manager IP :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>mgr</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mgr
set varbind [SA_getvar {sysObjectID.0}]
set vb1 [lindex $varbind 0]
set val1 [lindex $vb1 2]
set args [list $val1 0 0 ]
SA_settrapmgrs $mgr
SA_sendtrap $args</script>
</Template>
