<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_stop_tftp</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Disables support for TFTP for the simulated device.  Contact SimpleSoft for additional details on the FTP module support.

Example:  SA_stop_tftp.

Note:
The TFTP Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable TFTP capability and specify the root directory, then you do not need to specifiy the &quot;SA_start_tftp&quot;command in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <OutputVariables></OutputVariables>
 <script>SA_stop_tftp</script>
</Template>
