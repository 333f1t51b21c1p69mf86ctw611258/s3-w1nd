<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_debug</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Turns telnet debugging on/off.
Creates a debug file that contains a trace of the commands executed and the output of the SA_telnet_debugputs command.

These commands are supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Debug Flag</label>
   <type>2</type>
   <value>0</value>
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
  <Input>
   <label>Debug File</label>
   <type>1</type>
   <value>none</value>
   <variable>filename</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
set filename
SA_telnet_debugflag  $flag
SA_telnet_debugfile  $filename</script>
</Template>
