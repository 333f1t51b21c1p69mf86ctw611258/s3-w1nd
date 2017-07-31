<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getcuroid</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Gets the current object identifier for the varbind being processed.  In the case of getnext pdu processing, this oid will be different then the one reported by SA_getreqvb since the agent would have already advanced it to the lexicographically next oid.

Example: SA_getcuroid</Description>
 <OutputVariables></OutputVariables>
 <script>SA_getcuroid</script>
</Template>
