<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dumpvarfile</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Makes the Agent dump the contents of the MIB database into the specified file. This file can then be used as starting values for future simulations.

Example: SA_dumpvarfile  abcd.var</Description>
 <InputList>
  <Input>
   <label>File Name :</label>
   <type>1</type>
   <value>abc.var</value>
   <variable>filename</variable>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set filename
SA_dumpvarfile $filename</script>
</Template>
