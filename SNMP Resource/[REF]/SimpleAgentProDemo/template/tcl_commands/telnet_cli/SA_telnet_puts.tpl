<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_telnet_puts</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Prints out the line as defined in args on the telnet connection and sends it to the client.  By default, the SA_telnet_puts will both add a newline and do a flush(send the buffer) unless the optional flags &quot;-nonewline&quot; and &quot;-noflush&quot; are used.

This command is supported only in the telnet tcl interpretor.

Note:
   The Telenet Server Tcl commands are retained for backwards compatibility with earlier versions.  During the device definition, if you enable Telnet/CLI capability and specify the telnet modeling file and port number, then you do not need to specifiy the SA_start_telnet&quot; Tcl commands in the %init_action section of the device modeling file.  These commands will be automatically carried out for you.
</Description>
 <InputList>
  <Input>
   <label>Arguments</label>
   <type>1</type>
   <value>none</value>
   <variable>args</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set args
SA_telnet_puts #-nonewline #-noflush $args</script>
</Template>
