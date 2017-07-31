<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_addipaddr</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>This command adds one more ip address to the same device thread.  So SNMP requests coming on the specified port for this ipaddress will also be processed by the same simulated device thread in the context of the associated variable file.  Devices like routers often have multiple ip addresses to the same box containing the same MIB data. This helps in their simulation.  Only the first argument is mandatory.  If subnet is not specified, it is assumed to be &quot;255.255.255.0&quot;.  If mac is not specified it is assumed to be ?none?.  If port is not specified, it is assumed to be ?161?.  If interface is not specified (only on Solaris) it is assumed to be ?hme0?.  This command is only available in the unrestricted version.

Example: SA_addipaddr 192.168.100.1</Description>
 <InputList>
  <Input>
   <label>IP Address :</label>
   <type>1</type>
   <value>1.1.1.1</value>
   <variable>ip</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set ip
SA_addipaddr $ip</script>
</Template>
