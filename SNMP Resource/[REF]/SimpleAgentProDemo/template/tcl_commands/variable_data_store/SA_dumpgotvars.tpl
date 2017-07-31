<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_dumpgotvars</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Makes the Agent dump only those variables that have been accessed since startup into the specified file. This file can then be used as starting values for future simulations.  For this to be used, the MARKVARSREAD = YES option must be specified in the config.inp file.

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
SA_dumpgotvars $filename</script>
</Template>
