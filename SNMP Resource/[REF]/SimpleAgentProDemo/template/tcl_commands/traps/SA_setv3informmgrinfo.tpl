<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_setv3informmgrinfo</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Specifies SNMPv3 characteristics of the inform recepient manager. The command takes 12 order dependent arguments, where ip is the ipaddress of the manager, pt is its udp port, nr is the number of retries (you can set it to zero if no retries are needed), to is the timeout in secs to wait for the the response to the inform, ei is the engine id of the manager (you can set it to none to make SAPro do discovery), ci is the context engineid (you can set it to none to make it the same as engineid), cn is the context name (you can set it to none if not used), un is the username, sl is the security level (you can set it to one of the following: NoAuthNoPriv, AuthNoPriv, AuthPriv), at is the authentication type (you can set it to one of the following: MD5,SHA), ap is the authentication password, and pp is the privacy password.  If the engineid is ?discovered? it is remembered for subsequent inform transmissions to the same manager.

Example: SA_setv3informmgrinfo 192.168.100.90 162 3 1 none none none noAuthUser NoAuthNoPriv MD5 none none</Description>
 <InputList>
  <Input>
   <label>Manager IP :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>mgrip</variable>
  </Input>
  <Input>
   <label>UDP port :</label>
   <type>1</type>
   <value>162</value>
   <variable>udp_port</variable>
  </Input>
  <Input>
   <label>Number of Retries :</label>
   <type>1</type>
   <value>1</value>
   <variable>retries_num</variable>
  </Input>
  <Input>
   <label>Timeout (secs) :</label>
   <type>1</type>
   <value>1</value>
   <variable>time_out</variable>
  </Input>
  <Input>
   <label>Engine ID :</label>
   <type>1</type>
   <value>none</value>
   <variable>engine_id</variable>
  </Input>
  <Input>
   <label>Context Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>context_name</variable>
  </Input>
  <Input>
   <label>User Name :</label>
   <type>1</type>
   <value>none</value>
   <variable>user_name</variable>
  </Input>
  <Input>
   <label>Security Level :</label>
   <type>0</type>
   <value>0</value>
   <variable>sec_level</variable>
   <combomap>
    <mapitem>
     <displayval>AuthNoPriv</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>AuthPriv</displayval>
     <actualval>1</actualval>
    </mapitem>
    <mapitem>
     <displayval>NoAuthNoPriv</displayval>
     <actualval>2</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Authentication Type :</label>
   <type>0</type>
   <value>0</value>
   <variable>auth_type</variable>
   <combomap>
    <mapitem>
     <displayval>MD5</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>SHA</displayval>
     <actualval>1</actualval>
    </mapitem>
   </combomap>
  </Input>
  <Input>
   <label>Authentication Password :</label>
   <type>1</type>
   <value>none</value>
   <variable>auth_pass</variable>
  </Input>
  <Input>
   <label>Privacy Password :</label>
   <type>1</type>
   <value>none</value>
   <variable>priv_pass</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set mgrip
set udp_port
set retries_num
set time_out
set engine_id
set context_name
set user_name
set sec_level
set auth_type
set auth_pass
set priv_pass
SA_setv3informmgrinfo $mgrip $udp_port $retries_num $time_out $engine_id $context_name $user_name 				  $sec_level $auth $auth_pass $priv_pass</script>
</Template>
