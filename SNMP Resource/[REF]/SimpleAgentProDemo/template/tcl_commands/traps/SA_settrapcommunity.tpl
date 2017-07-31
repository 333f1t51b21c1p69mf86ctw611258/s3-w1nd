<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_settrapcommunity</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Sets the community string used in the traps generated.  By default the string used is public.

Example:  SA_settrapcommunity private</Description>
 <InputList>
  <Input>
   <label>Community String :</label>
   <type>0</type>
   <value>0</value>
   <variable>new_community</variable>
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
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set new_community
SA_settrapcommunity $new_community</script>
</Template>
