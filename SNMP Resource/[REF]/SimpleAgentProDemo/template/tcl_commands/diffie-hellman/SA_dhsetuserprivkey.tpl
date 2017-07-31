<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhsetuserprivkey</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the SNMPv3 priv keys used by the user based on the new values set for the usmDHUserPrivKeyChange and usmDHUserOwnPrivhKeyChange. An example in the Frequently Asked Section details the use of this command.

Example:  SA_dhsetuserprivkey oid newvalue</Description>
 <InputList>
  <Input>
   <label>OID :</label>
   <type>1</type>
   <value>0</value>
   <variable>oid</variable>
  </Input>
  <Input>
   <label>Value :</label>
   <type>1</type>
   <value>0</value>
   <variable>newvalue</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set oid
set newvalue
SA_dhsetuserprivkey $oid $newvalue</script>
</Template>
