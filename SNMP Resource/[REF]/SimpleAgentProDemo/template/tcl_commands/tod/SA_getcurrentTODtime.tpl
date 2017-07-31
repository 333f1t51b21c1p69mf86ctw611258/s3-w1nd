<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getcurrentTODtime</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Returns the number of seconds since 1970, if a previous call  had been made to a TOD server to get the time.  The time value will be incremented from the time it was retrieved.  This command fails if a previous call to SA_gettimefromTODServer was not made.

Example:set todtime [SA_gettimeFromTODServer]</Description>
 <OutputVariables></OutputVariables>
 <script>set todtime [SA_gettimeFromTODServer]</script>
</Template>
