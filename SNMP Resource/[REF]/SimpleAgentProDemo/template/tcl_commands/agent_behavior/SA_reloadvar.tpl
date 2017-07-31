<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_reloadvar</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command reloads the variable file specified in a running device. A new variable file can be reloaded, without stopping the entire map.  If the variable file name and compiled MIB file name are not specified, the files currently associated with the device are used.

Example: SA_reloadvar new_varfile_name  associated_compiled_mib_file_name</Description>
 <InputList>
  <Input>
   <label>Variable File :</label>
   <type>1</type>
   <value>none</value>
   <variable>new_varfile</variable>
  </Input>
  <Input>
   <label>Compiled MIB File :</label>
   <type>1</type>
   <value>none</value>
   <variable>compiled_mib_file</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set new_varfile
set compiled_mib_file
SA_reloadvar $new_varfile $compiled_mib_file</script>
</Template>
