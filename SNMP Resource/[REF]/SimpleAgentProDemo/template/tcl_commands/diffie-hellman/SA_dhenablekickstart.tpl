<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dhenablekickstart</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>If this command is present in the %init_action section of the modeling file, the variable file associated with the device is scanned for entries in the dhKickStart table.  For every entry in the dhKickStart table, a user is added to the list of users supported by the agent, and a new public key is computed and associated with the user.  The manager can then get the keys from the table and use them to derive auth/priv keys and start communicating with the agent.

Example:  SA_dhenablekickstart</Description>
 <OutputVariables></OutputVariables>
 <script>SA_dhenablekickstart</script>
</Template>
