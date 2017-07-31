<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_stopftpdaemon</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Disables support for FTP for the simulated device.   This command is only available on Solaris.  Contact SimpleSoft for additional details on the FTP module support.

Example: SA_stopftpdaemon

Note:
The FTP Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable FTP capability and specify the root directory and user list, then you do not need to specifiy the &quot;SA_startftpdaemon&quot; and &quot;SA_setftpusers&quot; commands in the device modeling file.  These commands will be automatically carried out for you.</Description>
 <OutputVariables></OutputVariables>
 <script>SA_stopftpdaemon</script>
</Template>
