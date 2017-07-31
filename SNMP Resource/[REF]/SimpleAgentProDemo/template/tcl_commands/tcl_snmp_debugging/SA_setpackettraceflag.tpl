<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setpackettraceflag</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the SNMP-related raw packet tracing on or off.  By default it is off.  When turned on, the sent and received packets are dumped out in a hex format.

Example:  SA_setpackettraceflag 1</Description>
 <InputList>
  <Input>
   <label>Trace Flag :</label>
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
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set flag 
SA_setpackettraceflag $flag</script>
</Template>
