<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_setlocalecho</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Tells the SimpleAgentPro to enable/disable local echo.  By default it is on, or set during telnet negotiation phase.  After telnet negotiation, it can be overwritten by setting it to 0 (disable) or 1(enable) in the %init_acton section..

Example:SA_telnet_setlocalecho 0

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.</Description>
 <InputList>
  <Input>
   <label>Locale Echo Flag</label>
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
SA_telnet_setlocalecho $flag</script>
</Template>
