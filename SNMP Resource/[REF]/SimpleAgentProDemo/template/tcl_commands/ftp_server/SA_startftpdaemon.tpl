<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_startftpdaemon</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Enables a FTP server to service requests for the simulated device.  Optional argument allows you to specify the root directory.  This command is only available on Solaris.   Contact SimpleSoft for additional details on the FTP module support.

Example: SA_startftpdaemon /tmp/dev1

Note:
The FTP Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable FTP capability and specify the root directory and user list, then you do not need to specifiy the &quot;SA_startftpdaemon&quot; and &quot;SA_setftpusers&quot; commands in the device modeling file.  These commands will be automatically carried out for you.
</Description>
 <InputList>
  <Input>
   <label>Root Directory :</label>
   <type>1</type>
   <value>none</value>
   <variable>root</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set root
SA_startftpdaemon  $root</script>
</Template>
