<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_reloadmodfile</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command reloads the modelling file associated with the device.  The init_action section is executed at the time of reloading.  Older timer actions are stopped and new ones started.  If the modelling file name is not specified, the current modelling file name is used.

Example: SA_reloadmodfile  new_modelling_file</Description>
 <InputList>
  <Input>
   <label>Modeling File :</label>
   <type>1</type>
   <value>none</value>
   <variable>mod_file</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mod_file
SA_reloadmodfile $mod_file</script>
</Template>
