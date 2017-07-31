<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_sendsnmp</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sends a snmp request without waiting for a reply to the specified ipaddress.  Only SNMPv1 or SNMPv2c is currently supported for versions and only &quot;set&quot; request is currently allowed.

Example:  SA_sendsnmp 192.168.100.40 161 SNMPv1 set private {{sysLocation.0 OctetString abc }}</Description>
 <InputList>
  <Input>
   <label>IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>ip</variable>
  </Input>
  <Input>
   <label>Port :</label>
   <type>1</type>
   <value>162</value>
   <variable>port</variable>
  </Input>
  <Input>
   <label>Version :</label>
   <type>0</type>
   <value>SNMPv2c</value>
   <variable>ver</variable>
   <combomap>
    <mapitem>
     <displayval>SNMPv1</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>SNMPv2c</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Operation :</label>
   <type>0</type>
   <value>0</value>
   <variable>oper</variable>
   <combomap>
    <mapitem>
     <displayval>set</displayval>
     <actualval>0</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Community :</label>
   <type>0</type>
   <value>0</value>
   <variable>community</variable>
   <combomap>
    <mapitem>
     <displayval>private</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>public</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>List of Varbinds :</label>
   <type>1</type>
   <value>varOid1 varType1 varVal1</value>
   <variable>varbinds</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ip
set port
set ver
set oper
set comnunity
set varbinds
SA_sendsnmp $ip $port $ver $oper $community { {$varbinds} }</script>
</Template>
