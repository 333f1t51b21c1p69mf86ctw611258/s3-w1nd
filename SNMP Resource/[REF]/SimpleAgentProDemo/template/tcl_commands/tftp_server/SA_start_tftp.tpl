<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_start_tftp</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Enables a TFTP server to service requests for the simulated device.  Optional argument allows you to specify the root directory and port if other than standard (69). Contact SimpleSoft for additional details on the TFTP module support.

Example: SA_start_tftp /tmp/dev1

Note:
The TFTP Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable TFTP capability and specify the root directory, then you do not need to specifiy the &quot;SA_start_tftp&quot;command in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Root Directory :</label>
   <type>1</type>
   <value>none</value>
   <variable>root</variable>
  </Input>
  <Input>
   <label>Port Number :</label>
   <type>1</type>
   <value>none</value>
   <variable>port</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set root
set port
SA_start_tftp  $root  $port</script>
</Template>
