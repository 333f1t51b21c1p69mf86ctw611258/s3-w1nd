<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendtclcmdtodev</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This sends the tcl command to be interpreted in the tcl interpretor of the specified device. 

Example: SA_sendtclcmdtodev 128.100.100.40  ?set abc 1?</Description>
 <InputList>
  <Input>
   <label>Device ID :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>dev_id</variable>
  </Input>
  <Input>
   <label>TCL Command :</label>
   <type>1</type>
   <value>none</value>
   <variable>tcl_cmd</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set dev_id
set tcl_cmd
SA_sendtclcmdtodev $dev_id $tcl_cmd</script>
</Template>
