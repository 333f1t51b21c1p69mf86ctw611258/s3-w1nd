<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setftpusers</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Specifies the users to be allowed ftp access for this simulated device. These users should be present in the /etc/passwd file. This command is only available on Solaris. Please contact SimpleSoft for additional details on the FTP module support.

Example:SA_setftpusers &quot;user1 user2 user3&quot;

Note:
The FTP Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable FTP capability and specify the root directory and user list, then you do not need to specifiy the &quot;SA_startftpdaemon&quot; and &quot;SA_setftpusers&quot; commands in the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>User List :</label>
   <type>1</type>
   <value>none</value>
   <variable>user_list</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set user_list
SA_setftpusers  $user_list</script>
</Template>
