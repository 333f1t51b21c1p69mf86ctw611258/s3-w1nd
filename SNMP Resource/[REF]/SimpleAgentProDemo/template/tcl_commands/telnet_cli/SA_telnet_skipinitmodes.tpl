<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_skipinitmodes</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to skip sending the initial sequence for session capabilities negotiation.  By default it is sent.

Example:SA_telnet_skipinitmodes 0

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Sequence Flag</label>
   <type>2</type>
   <value>1</value>
   <variable>flag</variable>
   <combomap>
    <mapitem>
     <displayval>off</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>on</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
SA_telnet_skipinitmodes $flag</script>
</Template>
