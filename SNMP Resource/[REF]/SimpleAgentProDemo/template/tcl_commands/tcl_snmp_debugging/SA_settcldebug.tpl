<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settcldebug</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the TCL-related debugging on or off. TCL debug information is only written to the file when both the tcldebugflag is enabled and TCL debug file is set.  When the flag is set to 2, only the output of the SA_puts and SA_debugputs are written to the file and all the internally generated trace messages are dropped.
Sets the TCL-related debugging information to be written to the specified file. TCL debug information is only written to the file when both the tcldebugflag is enabled and the TCL debug file is set.

Example: SA_settcldebugflag 1
	  SA_settcldebugfile abcd.dbg</Description>
 <InputList>
  <Input>
   <label>Debug Flag :</label>
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
    <mapitem>
     <displayval>output</displayval>
     <actualval>2</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Debug File :</label>
   <type>1</type>
   <value>file.dbg</value>
   <variable>filename</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
set filename
SA_settcldebugflag $flag
SA_settcldebugfile $filename</script>
</Template>
