<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setsnmpdebug</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the SNMP related debugging on or off.  SNMP debug  information is only written to the file when both the  snmpdebugflag is enabled and the SNMP debug file is set.   SNMP debug information includes a PDU dump of the requests  received and the responses generated.  When the value is set to 0, debugging is turned off.  When the value is set to 1, SNMP packets are dumped.  When the value is set to 2, error messages while  processing SNMP PDUs are dumped along with SNMP packets, and when the value is set to 3, only PDUs with error status set are dumped.
Sets the SNMP-related information to be written to the specified file. SNMP debug information is only written to the file when both the snmpdebugflag is enabled and SNMP debug file is set. SNMP debug information includes a PDU dump of the requests received and responses generated.

Example:  SA_setsnmpdebugflag 1
	   SA_setsnmpdebugfile abcd.snm</Description>
 <InputList>
  <Input>
   <label>Debug Flag :</label>
   <type>2</type>
   <value>1</value>
   <variable>flag</variable>
   <combomap>
    <mapitem>
     <displayval>err_msg</displayval>
     <actualval>2</actualval>
    </mapitem>
    <mapitem>
     <displayval>err_status</displayval>
     <actualval>3</actualval>
    </mapitem>
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
   <label>Debug File :</label>
   <type>1</type>
   <value>file.snm</value>
   <variable>filename</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag
set filename
SA_setsnmpdebugflag $flag
SA_setsnmpdebugfile $filename</script>
</Template>
