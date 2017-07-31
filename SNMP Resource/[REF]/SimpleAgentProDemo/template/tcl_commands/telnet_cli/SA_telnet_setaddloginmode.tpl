<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_setaddloginmode</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to disable addtional login(0), or have only password based additional login (2) with logoff if errors exceed the max retries allowed, or have only password based additional login with the session remaining in regular mode (3).  By default the additional login is disabled.

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Login Mode</label>
   <type>2</type>
   <value>0</value>
   <variable>flag</variable>
   <combomap>
    <mapitem>
     <displayval>disabled additional login</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>only passwd additional login</displayval>
     <actualval>2</actualval>
    </mapitem>
    <mapitem>
     <displayval>only passwd with session</displayval>
     <actualval>3</actualval>
    </mapitem>
   </combomap>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
SA_telnet_setaddloginmode $flag</script>
</Template>
