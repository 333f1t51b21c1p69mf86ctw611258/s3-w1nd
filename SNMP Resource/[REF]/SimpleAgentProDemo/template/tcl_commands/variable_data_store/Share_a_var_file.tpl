<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>Share_a_var_file</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>An example where you can share one .var file among many devices, and at runtime, the modeling file is used to populate IP Address sensitive tables with the appropriate data.</Description>
 <OutputVariables></OutputVariables>
 <script>set myip [SA_getmyip]
set vboid1 ipAdEntAddr.$myip
set vboid2 ipAdEntIfIndex.$myip
set vboid3 ipAdEntNetMask.$myip
set vboid4 ipAdEntBcastAddr.$myip
set vboid5 ipAdEntReasmMaxSize.$myip
set vb1     [list $vboid1 IpAddress $myip ]
set vb2     [list $vboid2 Integer   1 ]
set vb3     [list $vboid3 IpAddress 255.255.255.0 ]
set vb4     [list $vboid4 Integer   1 ]
set vb5     [list $vboid5 Integer   1500 ]
SA_setvar   [list $vb1 $vb2 $vb3 $vb4 $vb5]</script>
</Template>
