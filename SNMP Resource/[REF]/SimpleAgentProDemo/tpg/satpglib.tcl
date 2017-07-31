###############################################################################
#
# File:     satpglib.tcl
# Date:     2/1/2007
# Purpose:  Create project map from a topology data file
# Author:   SimpleSoft, Inc.
#
###############################################################################
global devices interfaces links crntDevID crntLnkIndex devIDList

###############################################################################
#
# Max ipNetToMedia hops -- This parameter controls how many hops away the
#                          the arp cache will contain. Increase or decease
#                          this value depending on your requirments
#
global maxArpCacheHops
set maxArpCacheHops 3

###############################################################################
#
# Max ipRouteTable hops -- This parameter controls how many hops away the
#                          the arp cache will contain. Increase or decease
#                          this value depending on your requirments
#
global maxRouteHops
set maxRouteHops 4

###############################################################################
#
# Parse Table -- Table used to parse the topology file. Give the tag, it parses
#                the line.
#
global parseTable

set parseTable(<Doc>) noAction
set parseTable(<DeviceList>) noAction
set parseTable(<Device) parseDevice
set parseTable(<DeviceProperties) parseDeviceProperties
set parseTable(</Device>) noAction
set parseTable(<InterfaceList>) noAction
set parseTable(<Interface) parseInterface
set parseTable(</InterfaceList>) noAction
set parseTable(</DeviceList>) noAction
set parseTable(<LinkList>) noAction
set parseTable(<Link) parseLink
set parseTable(</LinkList>) noAction
set parseTable(</Doc>) noAction

##############################################################################
#
# Procedure:    noAction
# Input:        None
# Output:       None
# Description:  The Procedure is used as a place holder the tags that do
#               not require anything done.
#
##############################################################################
proc noAction { inputLine } {}

##############################################################################
#
# Procedure:    parseDevice
# Input:        Source line from topology file
# Output:       An entry in the devices table and devIDList table
# Description:  The procedure parse the Device line in the Topology file and
#               adds the device I.D. the the device ID list (devIDList) and
#               adds entries in the devices array where the index is 
#               Device I.D. and variable name.
#
##############################################################################
proc parseDevice { inputLine } {
    global devices crntDevID devIDList

    # Look for the device's ID and save the rest of the parameters
    foreach var $inputLine {
        set var [split $var "="]
        set varName [lindex $var 0]
        set varValue [string trim [lindex $var 1] \"]

        if { $varName == "ID" } {
            set crntDevID $varValue
            lappend devIDList $varValue
        } elseif { $varName == ">" } {; # Found the end of the line
            break
        } else {
            lappend varList [list $varName $varValue]
        }
    }

    # Save the parameters in the device table using the ID as the index
    foreach var $varList {
        set devices($crntDevID,[lindex $var 0]) [lindex $var 1]
    }
}

##############################################################################
#
# Procedure:    parseDeviceProperties
# Input:        Source line from topology file
# Output:       Addition parameters to the current entry in the devices table
# Description:  This procedure parses the DeviceProperties lines in the
#               topology file and adds more parameters to the devices array.
#               The index into the devices array is device I.D. and 
#               parameter name.
#
##############################################################################
proc parseDeviceProperties { inputLine } {
    global devices crntDevID

    # Save the parameters in the device table using the ID as the index
    foreach var $inputLine {
        set var [split $var "="]
        set varName [lindex $var 0]
        if { $varName == "/>" } {;  # Found the end of the line
            break
        }
        set varValue [string trim [lindex $var 1] \"]

        set devices($crntDevID,$varName) $varValue
    }
}

##############################################################################
#
# Procedure:    parseInterface
# Input:        Source line from topology file
# Output:       An entry in the interfaces table
# Description:  This procedure parses the Interface lines in the topology file
#               and adds entries into the interfaces array. The index into 
#               this array is the current device I.D., the link's interface
#               number, and the parameter name.
#
##############################################################################
proc parseInterface { inputLine } {
    global interfaces crntDevID

    # Look for the device's ID and save the rest of the parameters
    foreach var $inputLine {
        set var [split $var "="]
        set varName [lindex $var 0]
        set varValue [string trim [lindex $var 1] \"]

        if { $varName == "InterfaceNumber" } {
            set crntIF $varValue
        } elseif { $varName == "/>" } {;    # Found the end of the line
            break
        } else {
            lappend varList [list $varName $varValue]
        }
    }

    # Save the parameters in the device table using the ID as the index
    foreach var $varList {
        set interfaces($crntDevID,$crntIF,[lindex $var 0]) [lindex $var 1]
    }
}

##############################################################################
#
# Procedure:    parseLink
# Input:        Source line from topology file
# Output:       Entry in the links table
# Description:  This procedure parses the Link lines in the topology file
#               and adds entries to the links array. The index for this array
#               is the current link index and the parameter name.
#
##############################################################################
proc parseLink { inputLine } {
    global links crntLnkIndex

    # Save the parameters in the device table using the ID as the index
    foreach var $inputLine {
        set var [split $var "="]
        set varName [lindex $var 0]
        if { $varName == "/>" } {;  # Found the end of the line
            break
        }
        set varValue [string trim [lindex $var 1] \"]

        set links($crntLnkIndex,$varName) $varValue
    }

    # Assign a random number to the link to be used when creating counters
    # for an interface. This is used as a beginning value so the the
    # input side and the output side will start with the same number.
    set links($crntLnkIndex,RandNum1) [expr int(rand() * 1000000) % 1000000]
    set links($crntLnkIndex,RandNum2) [expr int(rand() * 1000000) % 1000000]
    set links($crntLnkIndex,RandNum3) [expr int(rand() * 10000) % 10000]
    set links($crntLnkIndex,RandNum4) [expr int(rand() * 10000) % 10000]
    set links($crntLnkIndex,RandNum5) [expr int(rand() * 1000) % 1000]
    set links($crntLnkIndex,RandNum6) [expr int(rand() * 1000) % 1000]

    incr crntLnkIndex
}

##############################################################################
# 
# Procedure:    isCiscoDevice
# Input:        var file name (includes directory path)
# Output:       0 -- False
#               1 -- True
# Description:  The procedure determines whether the var file is for a Cisco
#               device. It searches for the sysObjectID and determines
#               if the OID has the Cisco enterprise number.
#
##############################################################################
proc isCiscoDevice { varFileName } {
    set rtnVal 0

    # Open the var file
    set sourceChannel [open $varFileName r]
    if { $sourceChannel > 0 } {

        # Search for sysObjectI
        while { [gets $sourceChannel sourceLine] >= 0 } {
            set found1 [string first "sysObjectID" $sourceLine]
            set found2 [string first "1.3.6.1.2.1.1.2.0" $sourceLine]

            # If sysObjectID found, check if it is a Cisco device
            if { $found1 >= 0 || $found2 >= 0 } {

                # If Cisco Device, then return true
                if { [string first "1.3.6.1.4.1.9" $sourceLine] >= 0 } {
                    set rtnVal 1
                }

                break;
            }
        }

        close $sourceChannel
    }

    return $rtnVal
}

##############################################################################
#
# Procedure:    getVarFile
# Input:        Device ID
# Output:       Path to var file
# Description:  Returns the device's template var file based on the Device's
#               I.D.
#
##############################################################################
proc getVarFile { devID } {
    global devices

    if { $devices($devID,userDefinedCmfVar) == "YES" } {
        if { $devices($devID,varName) == "" } {
            switch $devices($devID,Type) {
                0 {;    # Router = 0
                    set varFileName router.var
                }
                2 {;    # Switch = 2
                    set varFileName switch.var
                }
                3 {;    # Host = 3
                    set varFileName host.var
                }
                default continue
            }

            # copy in the rest of the var file
            set sourceFile [file join ../tpg $varFileName]
        } else {
            # copy in the rest of the var file
            set sourceFile $devices($devID,varName)
        }
    } else {
        # copy in the rest of the var file
        set sourceFile $devices($devID,vendorVarName)
    }

    return $sourceFile
}

##############################################################################
#
# Procedure:    convertAddrToOctetString
# Input:        IP address in dot format
# Output:       IP address in hex format
# Description:  Converts each decimal number of an IP address in dot format
#               to a hex number and concatinates the results
#
##############################################################################
proc convertAddrToOctetString { IPAddress } {
    # Make address into list
    set addrList [split $IPAddress "."]

    set rtnStr "0x"

    foreach subNum $addrList {
        set hexNum [format "%02x" $subNum]
        append rtnStr $hexNum
    }

    return $rtnStr
}

##############################################################################
#
# Procedure:    getToken
# Input:        token value
# Output:       token name
# Description:  Given a value this procedure searches the token string for a
#               device and returns the corresponding token name. If one can
#               not be found, then a new one is added
#
##############################################################################
proc getToken { devID tokenValue } {
    global tokenTable devices

    set found 0
    for {set i 1} {$i <= $tokenTable($devID,0)} {incr i} {
        if { $tokenTable($devID,$i) == $tokenValue } {
            set found $i
            break
        }
    } 

    if { $found == 0 } {
        if { $devices($devID,IPAddress) == $tokenValue } {
            return "\$\$MYIPADDRESS\$\$"
        }

        set mac $devices($devID,MACAddress)
        if { "0x${mac}" == $tokenValue } {
            return "\$\$MYMAINMACADDR\$\$"
        }

        incr tokenTable($devID,0)
        set found $tokenTable($devID,0)
        set tokenTable($devID,$found) $tokenValue

    }

    return "\$\$MYTOKENS[format %03d $found]\$\$"
}

##############################################################################
#
# Procedure:    TPG_parseparams
# Input:        On line from input file
# Output:       Creates a list of parameter/value pairs
# Description:  The procedure parses the given topology file line and creates
#               and returns a list of parameter/value pairs.
#
##############################################################################
proc TPG_parseparams { inputLine } {
    set crntToken ""
    set crntState Init
    set rtnList ""
    set firstQuoteFound 0
    
    for { set charIndex 0 } { $charIndex < [string length $inputLine] } { incr charIndex } {
        set crntChar [string index $inputLine $charIndex]
        switch -exact -- $crntChar {
            " " {
                switch $crntState {
                    Init {
                        # "Found first keyword"
                        lappend rtnList $crntToken
                        set crntToken ""
                        set crntState Var
                    }

                    Val {
                        # "Add space to token"
                        set crntToken [append crntToken $crntChar] 
                    }

                    default {
                        # "Ignore space"
                        continue
                    }
                }
            }
            
            "=" {
                switch $crntState {
                    Var {
                        # "Add equal to token and change state to Val"
                        set crntToken [append crntToken $crntChar] 
                        set crntState Val
                    }

                    default {
                        # "Ignore equal"
                        continue
                    }
                }
            }
            
            "\"" {
                switch $crntState {
                    Val {
                        if { $firstQuoteFound } {
                            # "Found second quote; store parm/val pair; state=Var"
                            set firstQuoteFound 0
                            lappend rtnList $crntToken

                            set crntToken ""
                            set crntState Var
                        } else {
                            # "Set first quote found flag"
                            set firstQuoteFound 1
                        }
                    }

                    default {
                        # "Ignore quote"
                        continue
                    }
                }
            }

            default {
                # "Append char to token"
                set crntToken [append crntToken $crntChar] 
            }
        }
    }


    lappend rtnList $crntToken
    return $rtnList
}

##############################################################################
#
# Procedure:    TPG_readtopologyfile
# Input:        Topology file name (include directory path)
# Output:       Creates 4 tables: devices, interfaces, links, and devIDList
# Description:  The procedure parses the given topology file and creates
#               4 tables which will be used to create a map file with its
#               corresponding cmf and var files.
#
##############################################################################
proc TPG_readtopologyfile { inputFile } {
    global devices interfaces links crntDevID crntLnkIndex parseTable devIDList
    
#   Initialize all the variables
    if [info exists devices] {
        unset devices;  # Clear the device list
    }
    if [info exists interfaces] {
        unset interfaces;    # Clear the interfaces list
    }
    if [info exists links] {
        unset links;    # Clear the link list
    }
    if [info exists devIDList] {
        unset devIDList;    # Clear the device ID list
    }
    set crntDevID 0; # Reset the device index
    set crntLnkIndex 1; # Reset the link index
    
#   open the input file for reading
    set inputChannel [open $inputFile r]

#   Parse each line in the file
    while { [gets $inputChannel inputLine]  > 0 } {
#       Get rid of leading blacks and parse line into tokens
        set inputLine [string trim $inputLine]
        set inputList [TPG_parseparams $inputLine]

#       Is this a comment line?
        if [string equal -length 2 [lindex $inputList 0] "<!"] {
            continue;   # Skip this line
        }

#       The first token becauses the index into the parse function table
        set tableIndex [lindex $inputList 0]
        $parseTable($tableIndex) [lrange $inputList 1 end]
    }

    close $inputChannel
}

##############################################################################
#
# Procedure:    TPG_readiftypefile
# Input:        None.
# Output:       Creates ifType table
# Description:  The procedure parses the ifType file and creates a table 
#               containing all the ifTypes supported and associated
#               parameters.
#
##############################################################################
proc TPG_readiftypefile { } {
    global ifTypeTable
    
    set ifTypeFile [file nativename [file join .. tpg iftype.cfg]]
    set inputChannel [open $ifTypeFile r]
    if [info exists ifTypeTable] {
        unset ifTypeTable
    }

#   Parse each line in the file
    while { [gets $inputChannel inputLine]  > 0 } {
        # Get rid of all the leading & trailing blanks
        set inputLine [string trim $inputLine]

        # Skip the line if it begins with a comment character
        if { [string first # $inputLine] == 0 } {
            continue
        }

        set values [split $inputLine ":"]

        set ifTypeTable([lindex $values 0],ifDescr) [lindex $values 2]
        set ifTypeTable([lindex $values 0],ifMtu) [lindex $values 3]
        set ifTypeTable([lindex $values 0],ifSpeed) [lindex $values 4]
    }

    if { [info exists ifTypeTable] == 0 } {
            ifTypeTable(6,ifDescr) Ethernet
            ifTypeTable(6,ifMtu) 1500
            ifTypeTable(6,ifSpeed) 10000000
    }

    close $inputChannel
}

##############################################################################
#
# Procedure:    getIfTypeValue
# Input:        ifType      ifType enumeration
#               ifValue     Name of ifType value (ifDescr, ifMTU, ifSpeed)
# Output:                   Returns corresponding value
# Description:  The procedure return value based on the ifType enumeration
#               and value name. If the enumeration does not exist, it 
#               returns the values for ethernet.
#
##############################################################################
proc getIfTypeValue {ifType valueName} {
    global ifTypeTable
    
    if [info exists ifTypeTable($ifType,$valueName)] {
        return $ifTypeTable($ifType,$valueName)
    } else {
        if { $valueName == "ifDescr" } {
            return Ethernet
        } elseif { $valueName == "ifMtu" } {
            return 1500
        } elseif { $valueName == "ifSpeed" } {
            return 10000000
        } else {
            return Unknown
        }
    }
}

##############################################################################
#
# Procedure:    getIfType
# Input:        devID       Device ID
#               ifIndex     Interface index
# Output:                   Returns corresponding ifType enumeration
# Description:  The procedure searches the link table for the device ID and 
#               interface index and returns the corresponding ifType
#               enumeration.
#
##############################################################################
proc getIfType {devID ifIndex} {
    global links crntLnkIndex
    
    # Go through the Link Table trying the find the given interface and device I.D.
    for { set i 1 } { $i < $crntLnkIndex } { incr i } {
        if { $links($i,interface1) == $ifIndex && $links($i,devID1) == $devID } {
            return $links($i,ifType)
        }

        if { $links($i,interface2) == $ifIndex && $links($i,devID2) == $devID } {
            return $links($i,ifType)
        }
    }

    # If we got this far, we didn't find a match. (This should never happen)
    # Return Ethernet
    return 6
}

##############################################################################
#
# Procedure:    TPG_genmapfile
# Input:        Project Name
# Output:       File containing SimpleAgentPro Map file
# Description:  The procedure creates a map file from the device information
#               found in the topology file.
#
##############################################################################
proc TPG_genmapfile { projName xmlFilePath dirName } {
    global devices devIDList cloneMap tokenTable

    # Generate the directories for the generated project
    if { ![file exists [file join $dirName $projName]] } {
        file mkdir [file join $dirName $projName]
    }

    set mapDir [file join $dirName $projName map] 
    if { ![file exists $mapDir] } {
        file mkdir $mapDir 
    }

    # open the map file
    if { [llength $devIDList] > 100 } {
        set mapCount 1
        set mapChannel [open [file join $mapDir ${projName}_1.map] w+]
    } else {
        set mapChannel [open [file join $mapDir $projName.map] w+]
    }

    if { $mapChannel == -1 } {
        return 1;   # Could not open map file for writing
    }

    # Initialize current device count. Note: Set to max so that it will write the map
    # header out initially. Set the first map flag so that we know we do not have to
    # close the current map and open a new one.
    set crntDevCount 100
    set firstMap 1

    foreach devID $devIDList {
        if { $crntDevCount >= 100 } {
            if { $firstMap != 1 } {
                puts $mapChannel "</DeviceMap>"
                close $mapChannel
                incr mapCount
                set mapChannel [open [file join $mapDir ${projName}_${mapCount}.map] w+]

                if { $mapChannel == -1 } {
                    return 1;   # Could not open map file for writing
                }
            } else {
                set firstMap 0
            }

            # Write the general map info
            puts $mapChannel "<DeviceMap"
            puts $mapChannel "    Release = \"5.0\""
            set timeStamp [clock format [clock seconds] -format "%D %T"]
            puts $mapChannel "    Description = \"Topology Editor Generated Map -- $timeStamp\""
            puts $mapChannel "    UserData = \"\""
            puts $mapChannel "    SetupFile = \"\""
            puts $mapChannel "    Interface = \"\""
            puts $mapChannel "    Separator = \":\""
            puts $mapChannel "    StartInterfaceNum = \"0\""

            set tpgFile [file nativename [file join $dirName tpg $xmlFilePath]]

            puts $mapChannel "    TPGFilePath = \"$tpgFile\""
            puts $mapChannel "    Username = \"John Doe\">"

            set crntDevCount 1
        } else {
            incr crntDevCount
        }

        puts $mapChannel "    <Device"
        puts $mapChannel "        <General"
        puts $mapChannel "            Name = \"$devices($devID,IPAddress)\""
        puts $mapChannel "            MultiHome = \"1\""
        puts $mapChannel "            DHCP = \"0\""
        puts $mapChannel "            SubnetMask = \"$devices($devID,mask)\""
        if { [string first "0x" $devices($devID,MACAddress)] == 0 } {
            puts $mapChannel "            MacAddress = \"[string range $devices($devID,MACAddress) 2 end]\""
        } else {
            puts $mapChannel "            MacAddress = \"$devices($devID,MACAddress)\""
        }
        puts $mapChannel "            Interface = \"\""
        puts $mapChannel "            UserData = \"\""

        # Add topology data if needed
        if { [info exists devices($devID,topologyData)] } {
            puts $mapChannel "            TopologyData = \"TOKENFILE=$devices($devID,topologyData)\""
        } elseif { [info exists tokenTable($devID,0)] && $tokenTable($devID,0) > 0 } {
            if { $tokenTable($devID,0) > 30 } {
                # create token file name 
                set tpdFile [file nativename [file join $dirName $projName var $devices($devID,IPAddress).tpd]]

                # Point the TopologyData to this file.
                puts $mapChannel "            TopologyData = \"TOKENFILE=$tpdFile\""

                # Open the token file and add the tokens
                set tpdFileChannel [open $tpdFile w+]
                if { $tpdFileChannel == -1 } {
                    return 1;   # Could not token file for writing
                }
                    
                # Add the tokens to the file
                for {set i 1} {$i <= $tokenTable($devID,0)} {incr i} {
                    puts $tpdFileChannel "$i=$tokenTable($devID,$i)"
                }

                # Close the token file
                close $tpdFileChannel
            } else {
                puts -nonewline $mapChannel "            TopologyData = \"$tokenTable($devID,1)"
                for {set i 2} {$i <= $tokenTable($devID,0)} {incr i} {
                    puts -nonewline $mapChannel ",$tokenTable($devID,$i)"
                }
                puts $mapChannel "\""     ;# Put a newline char at end of line
            }
        } else {
            puts $mapChannel "            TopologyData = \"\""
        }
        puts $mapChannel "            DisplayLogo = \"$devices($devID,vendorLogo)\""
        puts $mapChannel "            DisplayTag = \"$devices($devID,systemName)\""
        puts $mapChannel "            MultiHome = \"1\""
        puts $mapChannel "        />"
        if { $devices($devID,snmpEnabled) == "YES" } {
            puts $mapChannel "        <SNMP"
            puts $mapChannel "            ReadCommunity = \"public\""
            puts $mapChannel "            WriteCommunity = \"private\""

            if { $devices($devID,userDefinedCmfVar) == "YES" } {
                # if the cmf file is not specified, use the default
                if { $devices($devID,cmfName) == "" } {
                    switch $devices($devID,Type) {
                        0 {
                            set cmfName router.cmf
                        }
     
                        2 {
                            set cmfName switch.cmf
                        }
                     
                        3 {
                            set cmfName host.cmf
                        }
     
                        default {
                            set cmfName host.cmf
                        }
                    }
                } else {;   # Use the cmf file that was specified
                    set cmfName [file tail $devices($devID,cmfName)]
                }
            } else {
                set cmfName [file tail $devices($devID,vendorCmfName)]
            }
    
            set mibFile [file nativename [file join $dirName $projName cmf $cmfName]]
    
            puts $mapChannel "            MibFile = \"$mibFile\""
    
            set varFile [file nativename [file join $dirName $projName var $devices($devID,IPAddress).var]]
            puts $mapChannel "            AgentFile = \"$varFile\""
            puts $mapChannel "            TrapMgr = \"\""
            puts $mapChannel "            ResponseDelay = \"0\""

            if { $devices($devID,tclModelingFile) == "" } {
                set tclFile ""
            } else {
                set tclName [file tail $devices($devID,tclModelingFile)]
                set tclFile [file nativename [file join $dirName $projName tcl $tclName]]
            }
            puts $mapChannel "            ModelingFile = \"$tclFile\""
            puts $mapChannel "            SnmpStr = \"V1V2V3\""
            puts $mapChannel "            MtuSize = \"1500\""
            puts $mapChannel "            SnmpPort = \"161\""
            puts $mapChannel "            SecurityLevel = \"NoAuthNoPriv\""
            puts $mapChannel "        />"
        }
        if { $devices($devID,telnetEnabled) == "YES" } {
            puts $mapChannel "        <Telnet"
            if { $devices($devID,userDefinedTelnet) == "NO" } {
                puts $mapChannel "             TelnetLibraryDevice = \"$devices($devID,telnetVendorName)\""
            }
            puts $mapChannel "             TelnetPort = \"$devices($devID,telnetPort)\""
            set telnetName [file tail $devices($devID,telnetModelingFile)]
            set telnetFile [file nativename [file join $dirName $projName telnet $telnetName]]
            puts $mapChannel "             TelnetFile = \"$telnetFile\""
            puts $mapChannel "        />"
        }
        puts $mapChannel "    />"
    }

    puts $mapChannel "</DeviceMap>"

    close $mapChannel

    set tmpDir [file join $dirName $projName tl1] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName scenarios] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName tcl] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName trap] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName http] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName telnet] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName cmf] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    set tmpDir [file join $dirName $projName var] 
    if { ![file exists $tmpDir] } {
        file mkdir $tmpDir 
    }

    return 0;       # Map file created successfully
}

##############################################################################
#
# Procedure:    TPG_genvarfiles
# Input:        Project Name
# Output:       cmf/var file for each device in the map
# Description:  The procedure creates a cmf and var file from each device 
#               found in the topology file.
#
##############################################################################
proc TPG_genvarfiles { projName dirName } {
    global devices devIDList sortDone cancelGenMap varChannel

    # Generate the directories for the generated project
    if { ![file exists [file join $dirName $projName]] } {
        file mkdir [file join $dirName $projName]
    }

    set varDir [file join $dirName $projName var] 
    if { ![file exists $varDir] } {
        file mkdir $varDir
    }

    set cmfDir [file join $dirName $projName cmf] 
    if { ![file exists $cmfDir] } {
        file mkdir $cmfDir
    }

    # Generate a var file for each device
    foreach devID $devIDList {

        # if the Cancel button was pressed, then just stop here
        if { $cancelGenMap } {
            return
        }

        if { $devices($devID,telnetEnabled) == "YES" } {
            set telnetDir [file join $dirName $projName telnet] 
            if { ![file exists $telnetDir] } {
                file mkdir $telnetDir
            }

            set telnetFileName [file tail $devices($devID,telnetModelingFile)]
            set source $devices($devID,telnetModelingFile)

            # copy the cmf file if not there already
            set telnetName [file join $dirName $projName telnet $telnetFileName]
            if { ![file isfile $telnetName] } {
                file copy $source $telnetName
            }
        }

        # If SNMP is not enable, just go do the next device
        if { $devices($devID,snmpEnabled) == "NO" } {
            continue
        }

        if { $devices($devID,tclModelingFile) != "" } {
            set tclDir [file join $dirName $projName tcl] 
            if { ![file exists $tclDir] } {
                file mkdir $tclDir
            }

            set tclFileName [file tail $devices($devID,tclModelingFile)]
            set source $devices($devID,tclModelingFile)

            # copy the cmf file if not there already
            set tclName [file join $dirName $projName tcl $tclFileName]
            if { ![file isfile $tclName] } {
                file copy $source $tclName
            }
        }

        # Update status text
        TPG_updatestatustext "Creating $devices($devID,IPAddress).var..."

        if { $devices($devID,userDefinedCmfVar) == "YES" } {
            # If the CMF file was specified, then copy the file to the project
            if { $devices($devID,cmfName) == "" } {
                switch $devices($devID,Type) {
                    0 {;    # Router = 0
                        set cmfFileName router.cmf
                    }
                    2 {;    # Switch = 2
                        set cmfFileName switch.cmf
                    }
                    3 {;    # Host = 3
                        set cmfFileName host.cmf
                    }
                    default continue
                }

                set source [file join ../tpg $cmfFileName]
            } else {
                set cmfFileName [file tail $devices($devID,cmfName)]
                set source $devices($devID,cmfName)
            }
        } else {
            set cmfFileName [file tail $devices($devID,vendorCmfName)]
            set source $devices($devID,vendorCmfName)
        }

        # copy the cmf file if not there already
        set cmfName [file join $dirName $projName cmf $cmfFileName]
        if { ![file isfile $cmfName] } {
            file copy $source $cmfName
        }

        # open the var file
        set tmpFileName0 [file join $varDir $devices($devID,IPAddress).0.tmp]
        set varChannel [open $tmpFileName0 w+]

        if { $varChannel == -1 } {
            return 1;   # Could not open map file for writing
        }

        TPG_genvarfileheader $devID $varChannel

        if { $devices($devID,userDefinedCmfVar) == "YES" } {
            if { $devices($devID,varName) == "" } {
                switch $devices($devID,Type) {
                    0 {;    # Router = 0
                        set varFileName router.var
                    }
                    2 {;    # Switch = 2
                        set varFileName switch.var
                    }
                    3 {;    # Host = 3
                        set varFileName host.var
                    }
                    default continue
                }

                # copy in the rest of the var file
                set sourceFile [file join ../tpg $varFileName]
                set sourceChannel [open $sourceFile r]
                if { $sourceChannel > 0 } {
                    while { [gets $sourceChannel sourceLine] >= 0 } {
                        puts $varChannel $sourceLine
                    }
                }
                close $sourceChannel
                set filterFile 0
            } else {
                # copy in the rest of the var file
                set sourceFile $devices($devID,varName)
                set sourceChannel [open $devices($devID,varName) r]
                if { $sourceChannel > 0 } {
                    while { [gets $sourceChannel sourceLine] >= 0 } {
                        puts $varChannel $sourceLine
                    }
                }
                close $sourceChannel
                set filterFile 1
            }
        } else {
            # copy in the rest of the var file
            set sourceFile $devices($devID,vendorVarName)
            set sourceChannel [open $devices($devID,vendorVarName) r]
            if { $sourceChannel > 0 } {
                while { [gets $sourceChannel sourceLine] >= 0 } {
                    puts $varChannel $sourceLine
                }
            }
            close $sourceChannel
            set filterFile 1
        }

        if { $filterFile } {
            close $varChannel

            # Determine filter file name
            switch $devices($devID,Type) {
                0 {;    # Router = 0
                    set varFilterName router.flt
                }
                2 {;    # Switch = 2
                    set varFilterName switch.flt
                }
                3 {;    # Host = 3
                    set varFilterName host.flt
                }
                default continue
            }

            set tmpFileName [file join $varDir $devices($devID,IPAddress).tmp]
            set varFilterName [file join ../tpg $varFilterName]
        
            # Let vfilter run in background so we can check for windowing events
            set sortDone 0

            set filterPipe [open "|../bin/sapvfilter $tmpFileName0 $tmpFileName $varFilterName $cmfName"]
            if { $filterPipe <= 0 } {
                error "Filter Failed for $varFileName"
            }
            fileevent $filterPipe readable [list checkforEOF $filterPipe]
            vwait sortDone; # Wait here in the Tcl event loop until vfilter is done
        
            # Copy the filtered file to the scratch file
            file delete $tmpFileName0
            file rename $tmpFileName $tmpFileName0

            # Re-open the var file to add the new table entries
            set varChannel [open $tmpFileName0 a]
        }

        # Add the new table entries
        switch $devices($devID,Type) {
            0 {;    # Router = 0
                # Check if Cisco Device
                set ciscoDevice [isCiscoDevice $sourceFile]

                # Add in the topology specific information
                TPG_genroutervarfile $devID $ciscoDevice $varChannel
            }

            2 {;    # Switch = 2
                # Check if Cisco Device
                set ciscoDevice [isCiscoDevice $sourceFile]

                # Add in the topology specific information
                #TPG_genroutervarfile $devID $ciscoDevice $varChannel
                TPG_genswitchvarfile $devID $ciscoDevice $varChannel
            }

            3 {;    # Host = 3
                # Add in the topology specific information
                TPG_genhostvarfile $devID $varChannel
            }

            default continue
        }

        close $varChannel

        TPG_updatestepsdone
        
        # Sort the file in lexicagraphical order        
        set varFileName [file join $varDir $devices($devID,IPAddress).var]
        # Update status text
        TPG_updatestatustext "Sorting $devices($devID,IPAddress).var..."
        
        # Let vsort run in background so we can check for windowing events
        set sortDone 0
        set sortPipe [open "|../bin/sapvsort $tmpFileName0 $cmfName $varFileName"]
        if { $sortPipe <= 0 } {
            error "Sort Failed for $varFileName"
        }
        fileevent $sortPipe readable [list checkforEOF $sortPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vsort is done
        
        file delete $tmpFileName0

        TPG_updatestepsdone
    }
}

###############################################################################
#
# Procedure:    checkforEOF
# Input:        Pipe I.D.
# Output:       Setting for global variable sortDone if sorting is complete
# Description:  The callback procedure is called when output is written by
#               the var file sort command line utility. Once it detects the
#               utility is done (when the utility outputs a 0 length line), it
#               sets a global flag to tell vwait that the sort is done.
#
###############################################################################
proc checkforEOF { pipe } {
    global sortDone

    # Check for windowing events
    TPG_processwinevents

    gets $pipe line;    # just clear the pipe

    # If empty string, then must be done
    if { [string length $line] <= 0 } {
        catch {close $pipe}
        set sortDone 1
    }
}

###############################################################################
#
# Procedure:    TPG_genvarfileheader
# Input:        device I.D. and var file channel I.D.
# Output:       Header lines written to current var file being created
# Description:  This procedure writes out the header information in the current
#               var file being created.
#
###############################################################################
proc TPG_genvarfileheader { devID varChannel } {
    global devices interfaces links

    puts $varChannel "######################################################################"
    puts $varChannel "#"

    set timeStamp [clock format [clock seconds] -format "%D %T"]
    puts $varChannel "# Topology Editor generated var file -- $timeStamp"
    puts $varChannel "#"

    puts $varChannel "#"
    puts $varChannel "######################################################################"
}

###############################################################################
#
# Procedure:    TPG_getroutes
# Input:        interface   Interface number
#               devID       Device I.D.
#               subnet      Subnet address
# Output:       List of routes comprised of subnet address, subnet mask, and
#               next hop's IP address.
# Description:  This procedure returns all the next hops for building the IP
#               Route Table. The next hop is determined based on the peer's
#               device type on the other side of the link. If there is not
#               peer, then just return an empty list. If the peer is another
#               router this return all the IP addresses of the peer's
#               interfaces. If the peer is a switch, then iterate through 
#               each interface and determine the routes for that interface.
#               If the peer is a host, then there are no more routes, so 
#               return an empty list.
#
###############################################################################
proc TPG_getroutes { interface devID subnet {level 0} } {
    global devices interfaces links maxRouteHops

    # Initialize the return variable
    set rtnRoutes ""

    # Added a level parameter to prevent infinite loops since this 
    # procedure is call recursively
    incr level
    if { $level >= $maxRouteHops } return $rtnRoutes

    # Determine the peer's device I.D. and its IP address
    set peerDevID [TPG_getpeer $interface $devID]
    if [info exists devices($peerDevID,IPAddress) ] {
        set nextHop $devices($peerDevID,IPAddress)
    } else {
        set nextHop ""
    }

    # no peer on the otherside of this interface, just return
    if { $peerDevID == "" } {
        return $rtnRoutes
    }

    # switch based on the peer's device type
    switch $devices($peerDevID,Type) {
        0 {;    # Router = 0
            # Find the interface that is in the same subnet as the original device
            # to determine the next hop
            for { set i 1 } { $i < $devices($peerDevID,maxInterfaces) } { incr i } {
                if { [info exists interfaces($peerDevID,$i,subnet)] && $interfaces($peerDevID,$i,subnet) != "" } {
                    if { $subnet == $interfaces($peerDevID,$i,subnet) } {
                        set nextHop $interfaces($peerDevID,$i,IPAddress)
                    }
                }
            }

            # For each configured interface in the peer router, add the subnet of the peer
            # to the routes list if it does not match the subnet on the current interface
            # of the current device (that one has already been added to the table by the 
            # local route.
            for { set i 1 } { $i < $devices($peerDevID,maxInterfaces) } { incr i } {
                if { [info exists interfaces($peerDevID,$i,subnet)] && $interfaces($peerDevID,$i,subnet) != "" } {
                    if { $subnet != $interfaces($peerDevID,$i,subnet) } {
                        lappend rtnRoutes [list $interfaces($peerDevID,$i,subnet) $interfaces($peerDevID,$i,Mask) $nextHop]
                    }
                }
            }
        }

        2 {;    # Switch = 2
            # For each interface in the peer switch, add the routes found on the other
            # side of the link, if any and append it to the returned list
            for { set i 1 } { $i < $devices($peerDevID,maxInterfaces) } { incr i } {
                set peerDevID2 [TPG_getpeer $i $peerDevID]
                if { $peerDevID2 != "" && $peerDevID2 != $devID} {
                    if { [info exists interfaces($devID,$interface,subnet)] && $interfaces($devID,$interface,subnet) != "" } {
                        set peerRoutes [TPG_getroutes $i $peerDevID $interfaces($devID,$interface,subnet)]
                        if { $peerRoutes != "" } {
                            append rtnRoutes " "
                            append rtnRoutes $peerRoutes
                        }
                    }
                }
            }
        }

        3 {;    # Host = 3
                # no more routes
        }

        default {}
    }

    return $rtnRoutes
}

###############################################################################
#
# Procedure:    TPG_getpeerif
# Input:        interface   Interface number
#               devID       Device I.D.
# Output:       Interface number on the peer's side or empty string if there
#               is no peer
# Description:  This procedure returns returns the peer's interface number. It
#               searches the links table, trying to find a match base on a
#               given device's I.D. and interface number
#
###############################################################################
proc TPG_getpeerif { interface devID } {
    global devices interfaces links crntLnkIndex

    # Go through the Link Table trying the find the given interface and device I.D.
    for { set i 1 } { $i < $crntLnkIndex } { incr i } {
        if { $links($i,interface1) == $interface && $links($i,devID1) == $devID } {
            return $links($i,interface2)
        }

        if { $links($i,interface2) == $interface && $links($i,devID2) == $devID } {
            return $links($i,interface1)
        }
    }

    # If we got this far, we didn't find a match. (This should never happen)
    return ""
}

###############################################################################
#
# Procedure:    TPG_getpeer
# Input:        interface   Interface number
#               devID       Device I.D.
# Output:       Device I.D. of the peer or empty string if there is no peer
# Description:  This procedure returns returns the peer's device I.D. It
#               searches the links table, trying to find a match base on a
#               given device's I.D. and interface number
#
###############################################################################
proc TPG_getpeer { interface devID } {
    global devices interfaces links crntLnkIndex

    # Go through the Link Table trying the find the given interface and device I.D.
    for { set i 1 } { $i < $crntLnkIndex } { incr i } {

        # If interface1/devID1 matches, return the peers device ID
        if { $links($i,interface1) == $interface && $links($i,devID1) == $devID } {
            return $links($i,devID2)
        
        # If interface2/devID2 matches, return the peers device ID
        } elseif { $links($i,interface2) == $interface && $links($i,devID2) == $devID } { 
            return $links($i,devID1)
        }
    }

    # If we get down here, there was no link found
    return ""
}


###############################################################################
#
# Procedure:    TPG_chkdupinfo
# Input:        crntList    Current info list
#               newMember   New member
# Output:       Boolean indicting whether duplicate is detected: 1 - Yes and
#               0 - No.
# Description:  This procedure searches the current info list to make sure
#               there are no duplicates. Returns 1 if a duplicate is found 
#               and 0 if no duplicate detected.
#
###############################################################################
proc TPG_chkdupinfo { crntList newMember } {
    foreach info $crntList {
        if { $info == $newMember } {
            return 1
        }
    }

    return 0
}


###############################################################################
#
# Procedure:    TPG_getfwdinfo
# Input:        interface   Interface number
#               devID       Device I.D.
#               peerDevID   Peer's device I.D.
# Output:       List of forwarding info comprised of MAC addresses on the
#               other side of the link on which is connected to the given
#               interface.
# Description:  This procedure returns all the next forwarding addresses
#               on a given interface in order to build the FDB table in a
#               switch. In order to simplify the problem, this procedure
#               only return MAC addresses two hops away. If the peer is
#               a router, then all the MAC addresses in the router's active
#               interfaces are returned. If the peer is a switch, then all
#               the MAC addresses on hop away and the switches MAC
#               address is returned. IF the peer is a host, then the MAC
#               address of the host's interface is returned.
#
###############################################################################
proc TPG_getfwdinfo { interface devID peerDevID } {
    global devices interfaces links
    
    set forwardingList ""   ;# Initialize the returned list of addresses

    switch $devices($peerDevID,Type) {
        0 {;    # Router = 0
            set peerInterface [TPG_getpeerif $interface $devID]
            if [info exists interfaces($peerDevID,$peerInterface,MACAddress)] {
                if { [TPG_chkdupinfo $forwardingList $interfaces($peerDevID,$peerInterface,MACAddress)] == 0 } {
                    lappend forwardingList $interfaces($peerDevID,$peerInterface,MACAddress)
                }
            }
        }

        2 {;    # Switch = 2
            if { [TPG_chkdupinfo $forwardingList $devices($peerDevID,MACAddress)] == 0 } {
                lappend forwardingList $devices($peerDevID,MACAddress)
            }
            
            for {set j 1} {$j <= $devices($peerDevID,maxInterfaces)} {incr j} {
                set switchPeerDevID [TPG_getpeer $j $peerDevID]

                if {$switchPeerDevID != "" && $switchPeerDevID != $devID} {
                    switch $devices($switchPeerDevID,Type) {
                        0 {;    # Router = 0
                            set peerInterface [TPG_getpeerif $j $peerDevID]
                            if [info exists interfaces($switchPeerDevID,$peerInterface,MACAddress)] {
                                if { [TPG_chkdupinfo $forwardingList $interfaces($switchPeerDevID,$peerInterface,MACAddress)] == 0 } {
                                    lappend forwardingList $interfaces($switchPeerDevID,$peerInterface,MACAddress)
                                }
                            }
                        }

                        2 {;    # Switch = 2
                            if { [TPG_chkdupinfo $forwardingList $devices($switchPeerDevID,MACAddress)] == 0 } {
                                lappend forwardingList $devices($switchPeerDevID,MACAddress)
                            }
                        }

                        3 {;    # Host = 3
                            set peerInterface [TPG_getpeerif $j $peerDevID]
                            if [info exists interfaces($switchPeerDevID,$peerInterface,MACAddress)] {
                                if { [TPG_chkdupinfo $forwardingList $interfaces($switchPeerDevID,$peerInterface,MACAddress)] == 0 } {
                                    lappend forwardingList $interfaces($switchPeerDevID,$peerInterface,MACAddress)
                                }
                            }
                        }

                        default continue
                    }
                }
            }
        }

        3 {;    # Host = 3
            set peerInterface [TPG_getpeerif $interface $devID]
            if [info exists interfaces($peerDevID,$peerInterface,MACAddress)] {
                if { [TPG_chkdupinfo $forwardingList $interfaces($peerDevID,$peerInterface,MACAddress)] == 0 } {
                    lappend forwardingList $interfaces($peerDevID,$peerInterface,MACAddress)
                }
            }
        }

        default continue
    }

    return $forwardingList
}


###############################################################################
#
# Procedure:    TPG_getarpinfo
# Input:        interface   Interface number
#               devID       Device I.D.
#               peerDevID   Peer's device I.D.
# Output:       List of IP/MAC addr info comprised of MAC addresses and
#               corresponding IP addresses on the other side of the link.
# Description:  This procedure returns all the arp addresses on a given 
#               interface in order to build the atTable and ipNetToMedia 
#               table. If the peer is a switch, then all the addresses one 
#               hop away and the switch's address is returned. IF the peer 
#               is a router or host, then the address of the interface is 
#               returned.
#
###############################################################################
proc TPG_getarpinfo { interface devID peerDevID {level 0} } {
    global devices interfaces links maxArpCacheHops
    
    set arpList ""      ;# Initialize the returned list of addresses

    # Added a level parameter to prevent infinite loops since this 
    # procedure is call recursively
    incr level
    if { $level >= $maxArpCacheHops } return $arpList

    switch $devices($peerDevID,Type) {
        0 {;    # Router = 0
            # Get the peer's interface number and append the peer
            # interface's MAC and IP address.
            set peerIf [TPG_getpeerif $interface $devID]
            if [info exists interfaces($peerDevID,$peerIf,MACAddress)] {
                lappend arpList [list $interfaces($peerDevID,$peerIf,MACAddress) $interfaces($peerDevID,$peerIf,IPAddress)]
            }
        }

        2 {;    # Switch = 2
            # Get the peer's interface number and append the peer
            # interface's MAC and the device's IP address.
            set peerIf [TPG_getpeerif $interface $devID]
            if [info exists interfaces($peerDevID,$peerIf,MACAddress)] {
                lappend arpList [list $interfaces($peerDevID,$peerIf,MACAddress) $devices($peerDevID,IPAddress)]
            }

            # go thru all the switch's interfaces
            for {set j 1} {$j <= $devices($peerDevID,maxInterfaces)} {incr j} {
                set switchPeerDevID [TPG_getpeer $j $peerDevID]

                # if the switch's peer is the original device, then skip it
                if { $switchPeerDevID != $devID } {

                    # If there is a link, get all the arp info for that 
                    # interface and append them to the returned list
                    if { $switchPeerDevID != "" } {
                        set peerArpList [TPG_getarpinfo $j $peerDevID $switchPeerDevID $level]

                        foreach arpInfo $peerArpList {
                            lappend arpList $arpInfo
                        }
                    }
                }
            }
        }

        3 {;    # Host = 3
            # Get the peer's interface number and append the peer
            # interface's MAC and IP address.
            set peerIf [TPG_getpeerif $interface $devID]
            if [info exists interfaces($peerDevID,$peerIf,MACAddress)] {
                lappend arpList [list $interfaces($peerDevID,$peerIf,MACAddress) $interfaces($peerDevID,$peerIf,IPAddress)]
            }
        }

        default continue
    }

    return $arpList
}


###############################################################################
#
# Procedure:    TPG_getlinkend
# Input:        interface   Interface number
#               devID       Device I.D.
# Output:       
# Description:  
#
###############################################################################
proc TPG_getlinkend { interface devID } {
    global devices interfaces links crntLnkIndex

    for { set i 1 } { $i < $crntLnkIndex } { incr i } {

        if { $links($i,devID1) == $devID } {
            if { $links($i,interface1) == $interface } {
                return "1 $i"
            }
        } elseif { $links($i,devID2) == $devID } {
            if { $links($i,interface2) == $interface } {
                return "2 $i"
            }
        }
    }

    # If we get down here, there was no link found
    return "0 0"
}


###############################################################################
#
# Procedure:    TPG_genroutervarfile
# Input:        devID       Device I.D.
#               discoDevice Flag indicating if the device is Cisco
#               varChannel  Channel number of the var file being created
# Output:       New var file for a router
# Description:  This procedure creates a new var file for a router in the 
#               topology.
#
###############################################################################
proc TPG_genroutervarfile { devID ciscoDevice varChannel } {
    global devices interfaces links routeList cloneMap tokenTable

    if { $cloneMap } {
        set myIPAddr "\$\$MYIPADDRESS\$\$"
        set tokenTable($devID,0) 0      ;# Initialize token count
    } else {
        set myIPAddr $devices($devID,IPAddress)
    }

    # Add LLDP Remote and Remote Management Address Table. Add one row for each interface
    set lldpTableIndex 1
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]
        if { $peerDevID != "" } {
            if [isCiscoDevice [getVarFile $peerDevID]] {
                set peerIF [TPG_getpeerif $i $devID]
                # lldpRemPortIdSubtype
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.6.0.$i.$lldpTableIndex , Integer     , RO , fixed(1)"
                # lldpRemPortId
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.7.0.$i.$lldpTableIndex , OctetString , RO , fixed(Gi0/$i)"
                # lldpRemSysName
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.9.0.$i.$lldpTableIndex , OctetString , RO , fixed($devices($peerDevID,systemName))"

                # Add corresponding lldpRemAddrTable entry
                # lldpRemManAddrIfSubtype
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.3.0.$i.$lldpTableIndex.1.$devices($peerDevID,IPAddress), Integer , RO , fixed(2)"
                # lldpRemManAddrIfId
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.4.0.$i.$lldpTableIndex.1.$interfaces($peerDevID,$peerIF,IPAddress), Integer , RO , fixed($peerIF)"
                # lldpRemManAddrOID
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.5.0.$i.$lldpTableIndex.1.$interfaces($peerDevID,$peerIF,IPAddress), ObjectID , RO , fixed(0.0)"

                # Increment the lldpRemTable index
                incr lldpTableIndex
            }
        }
    }

    # Add the System Name
    # sysName.0
    puts $varChannel "1.3.6.1.2.1.1.5.0                     , OctetString , RW , r_lastset(0, 255, $devices($devID,systemName))"

    # Add the number of interfaces
    # ifNumber.0
    puts $varChannel "1.3.6.1.2.1.2.1.0                    , Integer     , RO , fixed($devices($devID,maxInterfaces))"

    # Add the Interfaces Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # Get which end of the link this interface is, if any
        set linkEnd [TPG_getlinkend $i $devID]
        set linkEndID [lindex $linkEnd 0]
        set linkIndex [lindex $linkEnd 1]

        # ifIndex.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.1.$i         , Integer     , RO , fixed($i)"
        # ifDescr.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.2.$i         , OctetString , RO , fixed([getIfTypeValue [getIfType $devID $i] ifDescr]$i/0)"
        # ifType.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.3.$i         , Integer     , RO , fixed([getIfType $devID $i])"
        # ifMtu.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.4.$i         , Integer     , RO , fixed([getIfTypeValue [getIfType $devID $i] ifMtu])"
        # ifSpeed.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.5.$i         , Gauge       , RO , fixed([getIfTypeValue [getIfType $devID $i] ifSpeed])"

        # ifPhysAddress.$i
        if [info exists interfaces($devID,$i,MACAddress)] {
            if { $cloneMap } {
                puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed("

                if { $interfaces($devID,$i,MACAddress) == $devices($devID,MACAddress) } {
                    puts -nonewline $varChannel "\$\$MYMAINMACADDR\$\$"
                } else {
                    # Save the value in the token table
                    incr tokenTable($devID,0)
                    set tokenTable($devID,$tokenTable($devID,0)) 0x$interfaces($devID,$i,MACAddress)

                    # Include token in var file
                    puts -nonewline $varChannel "\$\$MYTOKENS[format %03d $tokenTable($devID,0)]\$\$"
                }

                puts $varChannel ")"
            } else {
                puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed(0x$interfaces($devID,$i,MACAddress))"
            } 
        } else {
            puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed()"
        }

        # ifAdminStatus.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.7.$i         , Integer     , RW , r_lastset(1, 3, 1)"

        # ifOperStatus.$i
        if { $linkEndID > 0 } { ;# This I/F is linked, set status to "up(1)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(1)"
        } else {                ;# This I/F is not linked, set status to "down(2)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(2)"
        }

        # ifLastChange.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.9.$i         , TimeTicks   , RO , fixed(0)"
        # ifInOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.10.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.11.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.12.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.13.$i        , Counter     , RO , randomup(0, 0)"
        # ifInErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.14.$i        , Counter     , RO , randomup(0, 0)"
        # ifInUnknownProtos.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.15.$i        , Counter     , RO , randomup(0, 100)"

        # ifOutOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.16.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.17.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.18.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.19.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.20.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutQLen.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.21.$i        , Gauge       , RO , random(0, 100)"
        # ifSpecific.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.22.$i        , ObjectID    , RO , fixed(0.0)"
    }

    # Add the Address Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # Get the peer Dev I.D., if there's one there
        set peerDevID [TPG_getpeer $i $devID]

        # A peer is there
        if { $peerDevID != "" } {
            # Get the corresponding interface
            set peerInterface [TPG_getpeerif $i $devID]

            # Get the peer's IP and MAC address
            set macAddr $interfaces($peerDevID,$peerInterface,MACAddress)
            set ipAddr $interfaces($peerDevID,$peerInterface,IPAddress)

            if { $cloneMap } {
                set macAddr [getToken $devID 0x$macAddr]
                set ipAddr [getToken $devID $ipAddr]
            } else {
                set macAddr 0x$macAddr
            }

            # atIfIndex
            puts $varChannel "1.3.6.1.2.1.3.1.1.1.$i.1.$ipAddr  , Integer   , RW , lastset($i)"
            # atPhysAddress
            puts $varChannel "1.3.6.1.2.1.3.1.1.2.$i.1.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
            # atNetAddress
            puts $varChannel "1.3.6.1.2.1.3.1.1.3.$i.1.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
        }
    }

    # Make sure ipForwarding is enabled
    puts $varChannel "1.3.6.1.2.1.4.1.0       , Integer   , RW , r_lastset(1, 2, 1)"

    # Add the IP Addr Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        if { [info exists interfaces($devID,$i,IPAddress)] && $interfaces($devID,$i,IPAddress) != "" } {
            if { $cloneMap } {
                if { $interfaces($devID,$i,IPAddress) == $devices($devID,IPAddress) } {
                    set tokenStr \$\$MYIPADDRESS\$\$ 
                } else {
                    incr tokenTable($devID,0)
                    set tokenStr "\$\$MYTOKENS[format %03d $tokenTable($devID,0)]\$\$"
                    set tokenTable($devID,$tokenTable($devID,0)) $interfaces($devID,$i,IPAddress) 
                }

                # ipAdEntAddr
                puts $varChannel "1.3.6.1.2.1.4.20.1.1.$tokenStr     , IpAddress   , RO , fixed($tokenStr)" 
                # ipAdEntIfIndex
                puts $varChannel "1.3.6.1.2.1.4.20.1.2.$tokenStr     , Integer     , RO , fixed($i)" 
                # ipAdEntNetMask
                puts $varChannel "1.3.6.1.2.1.4.20.1.3.$tokenStr     , IpAddress   , RO , fixed($interfaces($devID,$i,Mask))" 
                # ipAdEntBcastAddr
                puts $varChannel "1.3.6.1.2.1.4.20.1.4.$tokenStr     , Integer     , RO , fixed(1)" 
                # ipAdEntReasmMaxSize
                puts $varChannel "1.3.6.1.2.1.4.20.1.5.$tokenStr     , Integer     , RO , fixed(18024)" 
            } else {
                # ipAdEntAddr
                puts $varChannel "1.3.6.1.2.1.4.20.1.1.$interfaces($devID,$i,IPAddress)     , IpAddress   , RO , fixed($interfaces($devID,$i,IPAddress))" 
                # ipAdEntIfIndex
                puts $varChannel "1.3.6.1.2.1.4.20.1.2.$interfaces($devID,$i,IPAddress)  , Integer     , RO , fixed($i)" 
                # ipAdEntNetMask
                puts $varChannel "1.3.6.1.2.1.4.20.1.3.$interfaces($devID,$i,IPAddress)  , IpAddress   , RO , fixed($interfaces($devID,$i,Mask))" 
                # ipAdEntBcastAddr
                puts $varChannel "1.3.6.1.2.1.4.20.1.4.$interfaces($devID,$i,IPAddress), Integer     , RO , fixed(1)" 
                # ipAdEntReasmMaxSize
                puts $varChannel "1.3.6.1.2.1.4.20.1.5.$interfaces($devID,$i,IPAddress), Integer     , RO , fixed(18024)" 
            }                
        }
    }

    # Add the IP Routing Table ******************************************

    # Add the local route
    # ipRouteDest.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.1.0.0.0.0  , IpAddress   , RW , lastset(0.0.0.0)"
    # ipRouteIfIndex.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.2.0.0.0.0  , Integer   , RW , lastset(1)"
    # ipRouteMetric1
    puts $varChannel "1.3.6.1.2.1.4.21.1.3.0.0.0.0  , Integer   , RW , lastset(1200)"
    # ipRouteMetric2.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.4.0.0.0.0  , Integer   , RW , lastset(10000)"
    # ipRouteMetric3
    puts $varChannel "1.3.6.1.2.1.4.21.1.5.0.0.0.0  , Integer   , RW , lastset(2000)"
    # ipRouteMetric4.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.6.0.0.0.0  , Integer   , RW , lastset(0)"
    # ipRouteNextHop.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.7.0.0.0.0  , IpAddress   , RW , lastset($myIPAddr)"
    # ipRouteType.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.8.0.0.0.0  , Integer   , RW , r_lastset(1, 4, 3)"
    # ipRouteProto.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.9.0.0.0.0  , Integer   , RW , lastset(2)"
    # ipRouteAge.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.10.0.0.0.0 , Integer   , RW , lastset(20)"
    # ipRouteMask.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.11.0.0.0.0 , IpAddress   , RW , lastset($devices($devID,mask))"
    # ipRouteMetric5.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.12.0.0.0.0 , Integer   , RW , lastset(255)"
    # ipRouteInfo.0.0.0.0
    puts $varChannel "1.3.6.1.2.1.4.21.1.13.0.0.0.0 , ObjectID   , RW , lastset(0.0)"

    set subnetList ""

    # Add the routes for each of the interfaces
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        if { [info exists interfaces($devID,$i,subnet)] && $interfaces($devID,$i,subnet) != "" } {
            if { [lsearch $subnetList $interfaces($devID,$i,subnet)] < 0 } {
                lappend subnetList $interfaces($devID,$i,subnet)
            } else {
                continue
            }
            if { $cloneMap } {
                incr tokenTable($devID,0)
                set tokenTable($devID,$tokenTable($devID,0)) $interfaces($devID,$i,subnet)
                set subnet "\$\$MYTOKENS[format %03d $tokenTable($devID,0)]\$\$"
            } else {
                set subnet $interfaces($devID,$i,subnet)
            }
            # ipRouteDest
            puts $varChannel "1.3.6.1.2.1.4.21.1.1.$subnet  , IpAddress , RW , lastset($subnet)"
            # ipRouteIfIndex
            puts $varChannel "1.3.6.1.2.1.4.21.1.2.$subnet  , Integer   , RW , lastset($i)"
            # ipRouteMetric1
            puts $varChannel "1.3.6.1.2.1.4.21.1.3.$subnet  , Integer   , RW , lastset(1200)"
            # ipRouteMetric2
            puts $varChannel "1.3.6.1.2.1.4.21.1.4.$subnet  , Integer   , RW , lastset(10000)"
            # ipRouteMetric3
            puts $varChannel "1.3.6.1.2.1.4.21.1.5.$subnet  , Integer   , RW , lastset(2000)"
            # ipRouteMetric4
            puts $varChannel "1.3.6.1.2.1.4.21.1.6.$subnet  , Integer   , RW , lastset(0)"
            # ipRouteNextHop
            if { $cloneMap } {
                puts $varChannel "1.3.6.1.2.1.4.21.1.7.$subnet  , IpAddress , RW , lastset([getToken $devID $interfaces($devID,$i,IPAddress)])"
            } else {
                puts $varChannel "1.3.6.1.2.1.4.21.1.7.$subnet  , IpAddress , RW , lastset($interfaces($devID,$i,IPAddress))"
            }
            # ipRouteType
            puts $varChannel "1.3.6.1.2.1.4.21.1.8.$subnet  , Integer   , RW , r_lastset(1, 4, 3)"
            # ipRouteProto
            puts $varChannel "1.3.6.1.2.1.4.21.1.9.$subnet  , Integer   , RW , lastset(2)"
            # ipRouteAge
            puts $varChannel "1.3.6.1.2.1.4.21.1.10.$subnet  , Integer   , RW , lastset(20)"
            # ipRouteMask
            puts $varChannel "1.3.6.1.2.1.4.21.1.11.$subnet  , IpAddress , RW , lastset($interfaces($devID,$i,Mask))"
            # ipRouteMetric5
            puts $varChannel "1.3.6.1.2.1.4.21.1.12.$subnet  , Integer  , RW , lastset(255)"
            # ipRouteInfo
            puts $varChannel "1.3.6.1.2.1.4.21.1.13.$subnet  , ObjectID , RW , lastset(0.0)"

            set routes [TPG_getroutes $i $devID $interfaces($devID,$i,subnet)]

            foreach route $routes {
                # Check for windowing events so the it doesn't appear frozen
                TPG_processwinevents

                # skip this subnet, if already in list
                if { [lsearch $subnetList [lindex $route 0]] < 0 } {
                    lappend subnetList [lindex $route 0]
                } else {
                    continue
                }

                if { $cloneMap } {
                    set subnet [getToken $devID [lindex $route 0]]
                } else {
                    set subnet [lindex $route 0]
                }

                # ipRouteDest
                puts $varChannel "1.3.6.1.2.1.4.21.1.1.$subnet  , IpAddress   , RW , lastset($subnet)"
                # ipRouteIfIndex
                puts $varChannel "1.3.6.1.2.1.4.21.1.2.$subnet  , Integer   , RW , lastset($i)"
                # ipRouteMetric1
                puts $varChannel "1.3.6.1.2.1.4.21.1.3.$subnet  , Integer   , RW , lastset(1200)"
                # ipRouteMetric2
                puts $varChannel "1.3.6.1.2.1.4.21.1.4.$subnet  , Integer   , RW , lastset(10000)"
                # ipRouteMetric3
                puts $varChannel "1.3.6.1.2.1.4.21.1.5.$subnet  , Integer   , RW , lastset(2000)"
                # ipRouteMetric4
                puts $varChannel "1.3.6.1.2.1.4.21.1.6.$subnet  , Integer   , RW , lastset(0)"
                # ipRouteNextHop
                if { $cloneMap } {
                    puts $varChannel "1.3.6.1.2.1.4.21.1.7.$subnet  , IpAddress   , RW , lastset([getToken $devID [lindex $route 2]])"
                } else {
                    puts $varChannel "1.3.6.1.2.1.4.21.1.7.$subnet  , IpAddress   , RW , lastset([lindex $route 2])"
                }
                # ipRouteType
                puts $varChannel "1.3.6.1.2.1.4.21.1.8.$subnet  , Integer   , RW , r_lastset(1, 4, 3)"
                # ipRouteProto
                puts $varChannel "1.3.6.1.2.1.4.21.1.9.$subnet  , Integer   , RW , lastset(2)"
                # ipRouteAge
                puts $varChannel "1.3.6.1.2.1.4.21.1.10.$subnet  , Integer   , RW , lastset(20)"
                # ipRouteMask
                puts $varChannel "1.3.6.1.2.1.4.21.1.11.$subnet  , IpAddress   , RW , lastset([lindex $route 1])"
                # ipRouteMetric5
                puts $varChannel "1.3.6.1.2.1.4.21.1.12.$subnet  , Integer   , RW , lastset(255)"
                # ipRouteInfo
                puts $varChannel "1.3.6.1.2.1.4.21.1.13.$subnet  , ObjectID   , RW , lastset(0.0)"
            }
        }
    }

    set arpCacheList ""

    # Add the IP Net To Media Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]

        if { $peerDevID != "" } {
            set ifArpList [TPG_getarpinfo $i $devID $peerDevID]
            foreach arpInfo $ifArpList {
                set macAddr [lindex $arpInfo 0]
                set ipAddr [lindex $arpInfo 1]

                if { [TPG_chkdupinfo $arpCacheList $i.$ipAddr] == 1 } {
                    continue
                } else {
                    lappend arpCacheList $i.$ipAddr
                }

                if { $cloneMap } {
                    set macAddr [getToken $devID 0x$macAddr]
                    set ipAddr [getToken $devID $ipAddr]
                } else {
                    set macAddr "0x$macAddr"
                }

                # ipNetToMediaIfIndex
                puts $varChannel "1.3.6.1.2.1.4.22.1.1.$i.$ipAddr  , Integer   , RW , lastset($i)"
                # ipNetToMediaPhysAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.2.$i.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
                # ipNetToMediaNetAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.3.$i.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
                # ipNetToMediaType
                puts $varChannel "1.3.6.1.2.1.4.22.1.4.$i.$ipAddr  , Integer   , RW , r_lastset(1, 4, 3)"
            }
        }
    }

    # Add UDP Table
    # udpLocalAddress
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.0.0.0.0.67    , IpAddress   , RO , fixed(0.0.0.0)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.49, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.161, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.1919, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.4786, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.5461, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.6350, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7558, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7879, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9768, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9968, IpAddress   , RO , fixed($myIPAddr)"
    # udpLocalPort
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.0.0.0.0.67       , Integer     , RO , fixed(67)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.49 , Integer     , RO , fixed(49)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.161, Integer     , RO , fixed(161)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.1919, Integer     , RO , fixed(1919)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.4786, Integer     , RO , fixed(4786)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.5461, Integer     , RO , fixed(5461)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.6350, Integer     , RO , fixed(6350)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7558, Integer     , RO , fixed(7558)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7879, Integer     , RO , fixed(7879)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9768, Integer     , RO , fixed(9768)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9968, Integer     , RO , fixed(9968)"

    # Add the Brige stats Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # dot3StatsIndex          
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.1.$i,    Integer, RO, fixed($i)"
        # dot3StatsAlignmentErrors            
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.2.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsFCSErrors      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.3.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsSingleCollisionFrames      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.4.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsMultipleCollisionFrames    
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.5.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsSQETestErrors  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.6.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsDeferredTransmissions      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.7.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsLateCollisions 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.8.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsExcessiveCollisions        
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.9.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInternalMacTransmitErrors  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.10.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsCarrierSenseErrors         
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.11.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsExcessiveDeferrals         
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.12.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsFrameTooLongs  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.13.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInRangeLengthErrors        
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.14.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsOutOfRangeLengthFields     
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.15.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInternalMacReceiveErrors   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.16.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsEtherChipSet   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.17.$i,    ObjectID, RO, fixed()" 
        # dot3StatsSymbolErrors   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.18.$i,    Counter, RO, fixed(0)"
        # dot3StatsDuplexStatus   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.19.$i,    Integer, RO, fixed(1)"
        # dot3StatsRateControlAbility 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.20.$i,    Integer, RO, fixed(1)"
        # dot3StatsRateControlStatus 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.21.$i,    Integer, RO, fixed(1)"
    }

    # Add the Extension to the Interfaces Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # ifName
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.1.$i       , OctetString, RO, fixed([string range [getIfTypeValue [getIfType $devID $i] ifDescr] 0 1]0/$i)"
        # ifInMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.2.$i       , Counter    , RO, randomup(, 100)"
        # ifInBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.3.$i       , Counter    , RO, randomup(, 100)"
        # ifOutMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.4.$i       , Counter    , RO, randomup(, 100)"
        # ifOutBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.5.$i       , Counter    , RO, randomup(, 100)"
        # ifHCInOctets
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.6.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInUcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.7.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.8.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.9.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutOctets
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.10.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutUcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.11.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.12.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.13.$i       , Counter64  , RO, randomup(0, 100)"
        # ifLinkUpDownTrapEnable
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.14.$i       , Integer    , RO, fixed(1)"
        # ifHighSpeed  
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.15.$i       , Gauge      , RO, random(10, 100)"
        # ifPromiscuousMode 
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.16.$i       , Integer    , RO, fixed(2)"
        # ifConnectorPresent
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.17.$i       , Integer    , RO, fixed(1)"
        # ifAlias
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.18.$i       , OctetString, RO, fixed()"
        # ifCounterDiscontinuityTime 
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.19.$i       , TimeTicks,   RO, fixed(0)"
    }

    # ifStackStatus
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.1    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.2    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.3    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.1.0    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.2.0    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.3.0    , Integer   , RO , fixed(1)"

    # Add timestamps so that NMS will think nothing has changed
    # ifTableLastChange       
    puts $varChannel "1.3.6.1.2.1.31.1.5.0      , TimeTicks , RO , fixed(0)"
    # ifStackLastChange       
    puts $varChannel "1.3.6.1.2.1.31.1.6.0      , TimeTicks , RO , fixed(1485)"

    # Add Cisco MIB objects if this is a Cisco device
    if { $ciscoDevice } {
        # Add CPU utilization MIB objects
        # busyPer                 
        puts $varChannel "1.3.6.1.4.1.9.2.1.56.0  , Integer , RO , utilization(5,2,10)"
        # avgBusy1                
        puts $varChannel "1.3.6.1.4.1.9.2.1.57.0  , Integer , RO , utilization(5,2,10)" 
        # avgBusy5                
        puts $varChannel "1.3.6.1.4.1.9.2.1.58.0  , Integer , RO , utilization(5,2,10)" 

        # Add cdpInterface Table. Add one row for each interface
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents
            
            set peerDevID [TPG_getpeer $i $devID]

            if { $peerDevID != "" } {
                if [info exists interfaces($devID,$i,IPAddress)] {
                    if [isCiscoDevice [getVarFile $peerDevID]] {
                        # cdpInterfaceEnable
                        puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.2.$i , Integer     , RW , r_lastset(1, 2, 1)"
                        # cdpInterfaceMessageInterval
                        puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.3.$i , Integer     , RW , r_lastset(5, 254, 60)"
                        # cdpInterfaceGroup
                        puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.4.$i , Integer     , RO , fixed(0)"
                        # cdpInterfacePort
                        puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.5.$i , Integer     , RO , fixed(0)"
                    }
                }
            }
        }

        # Add cdpCache Table. Add one row for each interface
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents
            
            set peerDevID [TPG_getpeer $i $devID]
            if { $peerDevID != "" } {
                if [isCiscoDevice [getVarFile $peerDevID]] {
                    # cdpCacheAddressType
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.3.$i.1 , Integer     , RO , fixed(1)"
                    if { $devices($peerDevID,Type) == 1 || 
                         $devices($peerDevID,Type) == 2 } {;    # peer is a hub or switch
                        if { $cloneMap } {
                            set addr [getToken $devID $devices($peerDevID,IPAddress)]
                        } else {
                            set addr $devices($peerDevID,IPAddress)
                        }
                    } else {;   # peer is router or host
                        set peerInterface [TPG_getpeerif $i $devID]
                        set peerIPAddr $interfaces($peerDevID,$peerInterface,IPAddress)

                        if { $cloneMap } {
                            set addr [getToken $devID $peerIPAddr]
                        } else {
                            set addr $peerIPAddr
                        }
                    }
                    # cdpCacheAddress
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.4.$i.1 , OctetString , RO , addr2str($addr)"
                    # cdpCacheAddress
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.5.$i.1 , OctetString , RO , fixed(0x436973636f20496e7465726e6574776f726b204f7065726174696e672053797374656d20536f667477617265200a494f532028746d29203430303020536f667477617265202858582d4a2d4d292c2056657273696f6e2031312e30283139292c2052454c4541534520534f4654574152452028666331290a436f707972696768742028632920313938362d3139393820627920636973636f2053797374656d732c20496e632e0a436f6d70696c6564204d6f6e2030322d4d61722d39382031393a3135206279206a617475726e6572)"
                    # cdpCacheDeviceId
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.6.$i.1 , OctetString , RO , fixed($devices($peerDevID,systemName))"
                    if { $devices($peerDevID,Type) == 3 } {;    # peer is a host
                        set portType "Intel(R) PRO/100+ PCI"
                    } else {;   # peer is router or host
                        set portType "[getIfTypeValue [getIfType $devID $i] ifDescr][TPG_getpeerif $i $devID]/0"
                    }
                    # cdpCacheDevicePort
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.7.$i.1 , OctetString , RO , fixed($portType)"
                    # cdpCachePlatform
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.8.$i.1 , OctetString , RO , fixed(Cisco Device)"

                    switch $devices($peerDevID,Type) {
                        0 {;    # Router = 0
                            set capabilities 0x00000001
                        }

                        2 {;    # Switch = 2
                            set capabilities 0x0000000e
                        }

                        3 {;    # Host = 3
                            set capabilities 0x00000000
                        }

                        default continue
                    }
                    # cdpCacheCapabilities
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.9.$i.1 , OctetString , RO , fixed($capabilities)"
                    # cdpCacheVTPMgmtDomain
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.10.$i.1, OctetString,  RO,  fixed()"
                    # cdpCacheNativeVLAN
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.11.$i.1, Integer,      RO,  fixed(0)"
                    # cdpCacheDuplex
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.12.$i.1, Integer,      RO,  fixed(1)"
                    # cdpCacheApplianceID
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.13.$i.1, Gauge,        RO,  fixed(0)"
                    # cdpCacheVlanID
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.14.$i.1, Gauge,        RO,  fixed(0)"
                    # cdpCachePowerConsumption
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.15.$i.1, Gauge,        RO,  fixed()"
                    # cdpCacheMTU            
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.16.$i.1, Gauge,        RO,  fixed([getIfTypeValue [getIfType $peerDevID $i] ifMtu])"
                    # cdpCacheSysName
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.17.$i.1, OctetString,  RO,  fixed($devices($peerDevID,systemName))"
                    # cdpCacheSysObjectID     
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.18.$i.1, ObjectID,     RO,  fixed()"
                    # cdpCachePrimaryMgmtAddrType 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.19.$i.1, Integer,      RO,  fixed()"
                    # cdpCachePrimaryMgmtAddr 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.20.$i.1, OctetString, RO,  fixed()" 
                    # cdpCacheSecondaryMgmtAddrType 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.21.$i.1, Integer,      RO,  fixed()"
                    # cdpCacheSecondaryMgmtAddr 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.22.$i.1, OctetString,  RO,  fixed()"
                    # cdpCachePhysLocation
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.23.$i.1, OctetString,  RO,  fixed(Lab)"
                    # cdpCacheLastChange      
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.24.$i.1, TimeTicks,    RO,  fixed(0)"
                }
            }
        }

        # Add the Cisco Queue Interface Table
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents

            # cQIfQType               
            puts $varChannel "1.3.6.1.4.1.9.9.37.1.1.1.1.$i,    Integer, RO, fixed(1)"
            # cQIfTxLimit             
            puts $varChannel "1.3.6.1.4.1.9.9.37.1.1.1.2.$i,    Integer, RO, fixed(4)"
            # cQIfSubqueues           
            puts $varChannel "1.3.6.1.4.1.9.9.37.1.1.1.3.$i,    Integer, RO, fixed(1)"
        }

        # Add the Cisco Queue Stats Table
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents

            # cQStatsDepth            
            for {set j 0} {$j < 264} {incr j} {
                puts $varChannel "1.3.6.1.4.1.9.9.37.1.2.1.2.$i.$j,  Gauge, RO, random(0, 100 )"
            }
            # cQStatsMaxDepth         
            for {set j 0} {$j < 264} {incr j} {
                puts $varChannel "1.3.6.1.4.1.9.9.37.1.2.1.3.$i.$j,  Gauge, RO, random(0, 100 )"
            }
            # cQStatsDiscards         
            for {set j 0} {$j < 264} {incr j} {
                puts $varChannel "1.3.6.1.4.1.9.9.37.1.2.1.4.$i.$j,  Gauge, RO, random(0, 100 )"
            }
        }

        # Add the Cisco Memory Pool Table
        # ciscoMemoryPoolName     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.1, OctetString, RO, fixed(Processor)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.2, OctetString, RO, fixed(I/O)"
        # ciscoMemoryPoolAlternate    
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.1, Integer, RO, fixed(2)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.2, Integer, RO, fixed(0)"
        # ciscoMemoryPoolValid    
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.1, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.2, Integer, RO, fixed(1)"
        # ciscoMemoryPoolUsed     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.1, Gauge  , RO, utilization(7, 2, 10)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.2, Gauge  , RO, utilization(7, 2, 10)"
        # ciscoMemoryPoolFree     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.1, Gauge  , RO, utilization(7, 2, 10)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.2, Gauge  , RO, utilization(7, 2, 10)"
        # ciscoMemoryPoolLargestFree  
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.1, Gauge  , RO, utilization(7, 2, 10)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.2, Gauge  , RO, utilization(7, 2, 10)"
        # ciscoMemoryPoolLowMemoryNotifThreshold
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.1, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.2, Integer, RW, r_lastset(0, 100, 20)"
    }
}

###############################################################################
#
# Procedure:    TPG_genswitchvarfile
# Input:        devID       Device I.D.
#               discoDevice Flag indicating if the device is Cisco
#               varChannel  Channel number of the var file being created
# Output:       New var file for a switch
# Description:  This procedure creates a new var file for a switch in the 
#               topology.
#
###############################################################################
proc TPG_genswitchvarfile { devID ciscoDevice varChannel } {
    global devices interfaces links cloneMap tokenTable

    if { $cloneMap } {
        set myIPAddr "\$\$MYIPADDRESS\$\$"
        set tokenTable($devID,0) 0      ;# Initialize token count
    } else {
        set myIPAddr $devices($devID,IPAddress)
    }

    # Add LLDP Remote and Remote Management Address Table. Add one row for each interface
    set lldpTableIndex 1
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]
        if { $peerDevID != "" } {
            if [isCiscoDevice [getVarFile $peerDevID]] {
                set peerIF [TPG_getpeerif $i $devID]
                # lldpRemPortIdSubtype
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.6.0.$i.$lldpTableIndex , Integer     , RO , fixed(1)"
                # lldpRemPortId
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.7.0.$i.$lldpTableIndex , OctetString , RO , fixed(Gi0/$i)"
                # lldpRemSysName
                puts $varChannel "1.0.8802.1.1.2.1.4.1.1.9.0.$i.$lldpTableIndex , OctetString , RO , fixed($devices($peerDevID,systemName))"

                # Add corresponding lldpRemAddrTable entry
                # lldpRemManAddrIfSubtype
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.3.0.$i.$lldpTableIndex.1.$devices($peerDevID,IPAddress), Integer , RO , fixed(2)"
                # lldpRemManAddrIfId
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.4.0.$i.$lldpTableIndex.1.$interfaces($peerDevID,$peerIF,IPAddress), Integer , RO , fixed($peerIF)"
                # lldpRemManAddrOID
                puts $varChannel "1.0.8802.1.1.2.1.4.2.1.5.0.$i.$lldpTableIndex.1.$interfaces($peerDevID,$peerIF,IPAddress), ObjectID , RO , fixed(0.0)"

                # Increment the lldpRemTable index
                incr lldpTableIndex
            }
        }
    }

    # Add the System Name
    # sysName.0
    puts $varChannel "1.3.6.1.2.1.1.5.0                 , OctetString , RW , r_lastset(0, 255, $devices($devID,systemName))"

    # Add the number of interfaces
    # ifNumber.0
    puts $varChannel "1.3.6.1.2.1.2.1.0             , Integer     , RO , fixed($devices($devID,maxInterfaces))"

    # Add the Interfaces Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # Get which end of the link this interface is, if any
        set linkEnd [TPG_getlinkend $i $devID]
        set linkEndID [lindex $linkEnd 0]
        set linkIndex [lindex $linkEnd 1]

        # ifIndex.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.1.$i         , Integer     , RO , fixed($i)"
        # ifDescr.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.2.$i         , OctetString , RO , fixed([getIfTypeValue [getIfType $devID $i] ifDescr]$i/0)"
        # ifType.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.3.$i         , Integer     , RO , fixed([getIfType $devID $i])"
        # ifMtu.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.4.$i         , Integer     , RO , fixed([getIfTypeValue [getIfType $devID $i] ifMtu])"
        # ifSpeed.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.5.$i         , Gauge       , RO , fixed([getIfTypeValue [getIfType $devID $i] ifSpeed])"

        # ifPhysAddress.$i
        if [info exists interfaces($devID,$i,MACAddress)] {
            if { $cloneMap } {
                puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed("

                if { $interfaces($devID,$i,MACAddress) == $devices($devID,MACAddress) } {
                    puts -nonewline $varChannel "\$\$MYMAINMACADDR\$\$"
                } else {
                    # Save the value in the token table
                    incr tokenTable($devID,0)
                    set tokenTable($devID,$tokenTable($devID,0)) 0x$interfaces($devID,$i,MACAddress)

                    # Include token in var file
                    puts -nonewline $varChannel "\$\$MYTOKENS[format %03d $tokenTable($devID,0)]\$\$"
                }

                puts $varChannel ")"
            } else {
                puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed(0x$interfaces($devID,$i,MACAddress))"
            } 
        } else {
            puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed()"
        }

        # ifAdminStatus.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.7.$i         , Integer     , RW , r_lastset(1, 3, 1)"

        # ifOperStatus.$i
        if { $linkEndID > 0 } { ;# This I/F is linked, set status to "up(1)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(1)"
        } else {                ;# This I/F is not linked, set status to "down(2)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(2)"
        }

        # ifLastChange.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.9.$i         , TimeTicks   , RO , fixed(0)"
        # ifInOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.10.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.11.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.12.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.13.$i        , Counter     , RO , randomup(0, 0)"
        # ifInErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.14.$i        , Counter     , RO , randomup(0, 0)"
        # ifInUnknownProtos.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.15.$i        , Counter     , RO , randomup(0, 100)"
        # ifOutOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.16.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.17.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.18.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.19.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.20.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutQLen.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.21.$i        , Gauge       , RO , random(0, 100)"
        # ifSpecific.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.22.$i        , ObjectID    , RO , fixed(0.0)"
    }

    # Add the Address Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # Get the peer Dev I.D., if there's one there
        set peerDevID [TPG_getpeer $i $devID]

        # A peer is there
        if { $peerDevID != "" } {
            # Get the corresponding interface
            set peerInterface [TPG_getpeerif $i $devID]

            # Get the peer's IP and MAC address
            set macAddr $interfaces($peerDevID,$peerInterface,MACAddress)
            set ipAddr $interfaces($peerDevID,$peerInterface,IPAddress)

            if { $cloneMap } {
                set macAddr [getToken $devID 0x$macAddr]
                set ipAddr [getToken $devID $ipAddr]
            } else {
                set macAddr 0x$macAddr
            }

            # atIfIndex
            puts $varChannel "1.3.6.1.2.1.3.1.1.1.$i.1.$ipAddr  , Integer   , RW , lastset($i)"
            # atPhysAddress
            puts $varChannel "1.3.6.1.2.1.3.1.1.2.$i.1.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
            # atNetAddress
            puts $varChannel "1.3.6.1.2.1.3.1.1.3.$i.1.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
        }
    }

    # Add the IP Addr Table
    # ipAdEntAddr
    puts $varChannel "1.3.6.1.2.1.4.20.1.1.$myIPAddr     , IpAddress   , RO , fixed($myIPAddr)"
    # ipAdEntIfIndex
    puts $varChannel "1.3.6.1.2.1.4.20.1.2.$myIPAddr     , Integer     , RO , fixed(1)"
    # ipAdEntNetMask
    puts $varChannel "1.3.6.1.2.1.4.20.1.3.$myIPAddr     , IpAddress   , RO , fixed($devices($devID,mask))"
    # ipAdEntBcastAddr
    puts $varChannel "1.3.6.1.2.1.4.20.1.4.$myIPAddr     , Integer     , RO , fixed(1)"
    # ipAdEntReasmMaxSize
    puts $varChannel "1.3.6.1.2.1.4.20.1.5.$myIPAddr     , Integer     , RO , fixed(18024)"

    set arpCacheList ""

    # Add the IP Net To Media Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]

        if { $peerDevID != "" } {
            set ifArpList [TPG_getarpinfo $i $devID $peerDevID]
            foreach arpInfo $ifArpList {
                set macAddr [lindex $arpInfo 0]
                set ipAddr [lindex $arpInfo 1]

                if { [TPG_chkdupinfo $arpCacheList $i.$ipAddr] == 1 } {
                    continue
                } else {
                    lappend arpCacheList $i.$ipAddr
                }

                if { $cloneMap } {
                    set macAddr [getToken $devID 0x$macAddr]
                    set ipAddr [getToken $devID $ipAddr]
                } else {
                    set macAddr "0x$macAddr"
                }

                # ipNetToMediaIfIndex
                puts $varChannel "1.3.6.1.2.1.4.22.1.1.$i.$ipAddr  , Integer   , RW , lastset($i)"
                # ipNetToMediaPhysAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.2.$i.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
                # ipNetToMediaNetAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.3.$i.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
                # ipNetToMediaType
                puts $varChannel "1.3.6.1.2.1.4.22.1.4.$i.$ipAddr  , Integer   , RW , r_lastset(1, 4, 3)"
            }
        }
    }

    # Add UDP Table
    # udpLocalAddress
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.0.0.0.0.67    , IpAddress   , RO , fixed(0.0.0.0)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.49, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.161, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.1919, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.4786, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.5461, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.6350, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7558, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7879, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9768, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9968, IpAddress   , RO , fixed($myIPAddr)"
    # udpLocalPort
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.0.0.0.0.67       , Integer     , RO , fixed(67)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.49 , Integer     , RO , fixed(49)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.161, Integer     , RO , fixed(161)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.1919, Integer     , RO , fixed(1919)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.4786, Integer     , RO , fixed(4786)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.5461, Integer     , RO , fixed(5461)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.6350, Integer     , RO , fixed(6350)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7558, Integer     , RO , fixed(7558)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7879, Integer     , RO , fixed(7879)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9768, Integer     , RO , fixed(9768)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9968, Integer     , RO , fixed(9968)"

    # Add the Bridge stats Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # dot3StatsIndex          
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.1.$i,    Integer, RO, fixed($i)"
        # dot3StatsAlignmentErrors            
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.2.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsFCSErrors      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.3.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsSingleCollisionFrames      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.4.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsMultipleCollisionFrames    
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.5.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsSQETestErrors  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.6.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsDeferredTransmissions      
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.7.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsLateCollisions 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.8.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsExcessiveCollisions        
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.9.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInternalMacTransmitErrors  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.10.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsCarrierSenseErrors         
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.11.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsExcessiveDeferrals         
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.12.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsFrameTooLongs  
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.13.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInRangeLengthErrors        
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.14.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsOutOfRangeLengthFields     
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.15.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsInternalMacReceiveErrors   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.16.$i,    Counter, RO, randomup(0, 100)"
        # dot3StatsEtherChipSet   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.17.$i,    ObjectID, RO, fixed()" 
        # dot3StatsSymbolErrors   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.18.$i,    Counter, RO, fixed(0)"
        # dot3StatsDuplexStatus   
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.19.$i,    Integer, RO, fixed(1)"
        # dot3StatsRateControlAbility 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.20.$i,    Integer, RO, fixed(1)"
        # dot3StatsRateControlStatus 
        puts $varChannel "1.3.6.1.2.1.10.7.2.1.21.$i,    Integer, RO, fixed(1)"
    }

    # Add number of Bridge ports
    # dot1dBaseNumPorts
    puts $varChannel "1.3.6.1.2.1.17.1.2.0              , Integer     , RO , fixed($devices($devID,maxInterfaces))"

    # Add Bridge Type: transparent-only(2)
    # dot1dBaseType
    puts $varChannel "1.3.6.1.2.1.17.1.3.0                  , Integer     , RO , fixed(2)"

    # Add Bridge port table
    set peerList ""
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # dot1dBasePort
        puts $varChannel "1.3.6.1.2.1.17.1.4.1.1.$i        , Integer     , RO , fixed($i)"
        # dot1dBasePortIfIndex
        puts $varChannel "1.3.6.1.2.1.17.1.4.1.2.$i        , Integer     , RO , fixed($i)"
        # dot1dBasePortCircuit
        puts $varChannel "1.3.6.1.2.1.17.1.4.1.3.$i        , ObjectID    , RO , fixed(0.0)"
        # dot1dBasePortDelayExceededDiscards
        puts $varChannel "1.3.6.1.2.1.17.1.4.1.4.$i, Counter     , RO , randomup(0, 100)"
        # dot1dBasePortMtuExceededDiscards
        puts $varChannel "1.3.6.1.2.1.17.1.4.1.5.$i, Counter     , RO , randomup(0, 100)"
        set peerDevID [TPG_getpeer $i $devID]
        if { $peerDevID != "" } {
            lappend peerList [list $i $peerDevID]
        }
    }

    # Add Forwarding Database
    
    set macAddrList ""
    set fwdTable ""

    # Determine MAC Address on the other side of the link
    foreach peerInfo $peerList {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set interface [lindex $peerInfo 0]
        set peerDevID [lindex $peerInfo 1]
        set forwardList [TPG_getfwdinfo $interface $devID $peerDevID]

        foreach fwdMAC $forwardList {
            if { [TPG_chkdupinfo $fwdTable $fwdMAC] == 1 } {
                continue
            } else {
                lappend fwdTable $fwdMAC
            }
            # Convert the MAC to an index
            scan $fwdMAC "%02x%02x%02x%02x%02x%02x" subID1 subID2 subID3 subID4 subID5 subID6 

            set subID1 [format "%d" $subID1]
            set subID2 [format "%d" $subID2]
            set subID3 [format "%d" $subID3]
            set subID4 [format "%d" $subID4]
            set subID5 [format "%d" $subID5]
            set subID6 [format "%d" $subID6]

            set macIndex "$subID1.$subID2.$subID3.$subID4.$subID5.$subID6"

            if { $cloneMap } {
                set macIndex [getToken $devID $macIndex]
                set fwdMAC [getToken $devID $fwdMAC]
            }

            # dot1dTpFdbAddress
            puts $varChannel "1.3.6.1.2.1.17.4.3.1.1.$macIndex, OctetString     , RO , fixed(0x$fwdMAC)"
            # dot1dTpFdbPort
            puts $varChannel "1.3.6.1.2.1.17.4.3.1.2.$macIndex, Integer        , RO , fixed($interface)"
            # dot1dTpFdbStatus
            puts $varChannel "1.3.6.1.2.1.17.4.3.1.3.$macIndex, Integer      , RO , fixed(3)"
        }
    }

    # Add the Extension to the Interfaces Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # ifName
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.1.$i       , OctetString, RO, fixed([string range [getIfTypeValue [getIfType $devID $i] ifDescr] 0 1]0/$i)"
        # ifInMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.2.$i       , Counter    , RO, randomup(, 100)"
        # ifInBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.3.$i       , Counter    , RO, randomup(, 100)"
        # ifOutMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.4.$i       , Counter    , RO, randomup(, 100)"
        # ifOutBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.5.$i       , Counter    , RO, randomup(, 100)"
        # ifHCInOctets
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.6.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInUcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.7.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.8.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCInBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.9.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutOctets
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.10.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutUcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.11.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutMulticastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.12.$i       , Counter64  , RO, randomup(0, 100)"
        # ifHCOutBroadcastPkts
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.13.$i       , Counter64  , RO, randomup(0, 100)"
        # ifLinkUpDownTrapEnable
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.14.$i       , Integer    , RO, fixed(1)"
        # ifHighSpeed  
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.15.$i       , Gauge      , RO, random(10, 100)"
        # ifPromiscuousMode 
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.16.$i       , Integer    , RO, fixed(2)"
        # ifConnectorPresent
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.17.$i       , Integer    , RO, fixed(1)"
        # ifAlias
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.18.$i       , OctetString, RO, fixed()"
        # ifCounterDiscontinuityTime 
        puts $varChannel "1.3.6.1.2.1.31.1.1.1.19.$i       , TimeTicks,   RO, fixed(0)"
    }

    # Add ifStackStatus
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.1    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.2    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.0.3    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.1.0    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.2.0    , Integer   , RO , fixed(1)"
    puts $varChannel "1.3.6.1.2.1.31.1.2.1.3.3.0    , Integer   , RO , fixed(1)"

    # Add timestamps so that NMS will think nothing has changed
    # ifTableLastChange       
    puts $varChannel "1.3.6.1.2.1.31.1.5.0      , TimeTicks , RO , fixed(0)"
    # ifStackLastChange       
    puts $varChannel "1.3.6.1.2.1.31.1.6.0      , TimeTicks , RO , fixed(1485)"

    # Add Cisco MIB objects if this is a Cisco Device
    if { $ciscoDevice } {
        # Add cdpInterface Table. Add one row for each active interface
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents
            
            foreach peerInfo $peerList {
                # Check for windowing events so the it doesn't appear frozen
                TPG_processwinevents

                set interface [lindex $peerInfo 0]
                set peerDevID [lindex $peerInfo 1]

                if [isCiscoDevice [getVarFile $peerDevID]] {
                    # cdpInterfaceEnable
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.2.$interface , Integer     , RW , r_lastset(1, 2, 1)"
                    # cdpInterfaceMessageInterval
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.3.$interface , Integer     , RW , r_lastset(5, 254, 60)"
                    # cdpInterfaceGroup
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.4.$interface , Integer     , RO , fixed(0)"
                    # cdpInterfacePort
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.1.1.1.5.$interface , Integer     , RO , fixed(0)"
                }
            }
        }

        # Add cdpCache Table. Add one row for each interface
        for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
            # Check for windowing events so the it doesn't appear frozen
            TPG_processwinevents
            
            set peerDevID [TPG_getpeer $i $devID]
            if { $peerDevID != "" } {
                if [isCiscoDevice [getVarFile $peerDevID]] {
                    # cdpCacheAddressType 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.3.$i.1 , Integer     , RO , fixed(1)"
                    if { $devices($peerDevID,Type) == 1 || 
                         $devices($peerDevID,Type) == 2 } {;    # peer is a hub or switch
                        if { $cloneMap } {
                            set addr [getToken $devID $devices($peerDevID,IPAddress)]
                        } else {
                            set addr $devices($peerDevID,IPAddress)
                        }
                    } else {;   # peer is router or host
                        set peerInterface [TPG_getpeerif $i $devID]
                        set peerIPAddr $interfaces($peerDevID,$peerInterface,IPAddress)

                        if { $cloneMap } {
                            set addr [getToken $devID $peerIPAddr]
                        } else {
                            set addr $peerIPAddr
                        }
                    }
                    # cdpCacheAddress
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.4.$i.1 , OctetString , RO , addr2str($addr)"
                    # cdpCacheVersion
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.5.$i.1 , OctetString , RO , fixed(0x57532d433535303520536f6674776172652c2056657273696f6e204d637053573a20352e3128316129204e6d7053573a20352e31283161290a436f707972696768742028632920313939352d3139393920627920436973636f2053797374656d730a)"
                    # cdpCacheDeviceId
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.6.$i.1 , OctetString , RO , fixed($devices($peerDevID,systemName))"
                    if { $devices($peerDevID,Type) == 3 } {;    # peer is a host
                        set portType "Intel(R) PRO/100+ PCI"
                    } else {;   # peer is router or switch
                        set portType "[getIfTypeValue [getIfType $devID $i] ifDescr][TPG_getpeerif $i $devID]/0"
                    }
                    # cdpCacheDevicePort
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.7.$i.1 , OctetString , RO , fixed($portType)"
                    #cdpCachePlatform
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.8.$i.1 , OctetString , RO , fixed(Cisco Device)"

                    switch $devices($peerDevID,Type) {
                        0 {;    # Router = 0
                            set capabilities 0x00000001
                        }

                        2 {;    # Switch = 2
                            set capabilities 0x0000000e
                        }

                        3 {;    # Host = 3
                            set capabilities 0x00000000
                        }

                        default continue
                    }
                    # cdpCacheCapabilities
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.9.$i.1 , OctetString , RO , fixed($capabilities)"
                    # cdpCacheVTPMgmtDomain
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.10.$i.1, OctetString,  RO,  fixed()"
                    # cdpCacheNativeVLAN
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.11.$i.1, Integer,      RO,  fixed(0)"
                    # cdpCacheDuplex
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.12.$i.1, Integer,      RO,  fixed(1)"
                    # cdpCacheApplianceID
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.13.$i.1, Gauge,        RO,  fixed(0)"
                    # cdpCacheVlanID
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.14.$i.1, Gauge,        RO,  fixed(0)"
                    # cdpCachePowerConsumption
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.15.$i.1, Gauge,        RO,  fixed()"
                    # cdpCacheMTU            
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.16.$i.1, Gauge,        RO,  fixed([getIfTypeValue [getIfType $peerDevID $i] ifMtu])"
                    # cdpCacheSysName
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.17.$i.1, OctetString,  RO,  fixed($devices($peerDevID,systemName))"
                    # cdpCacheSysObjectID     
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.18.$i.1, ObjectID,     RO,  fixed()"
                    # cdpCachePrimaryMgmtAddrType 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.19.$i.1, Integer,      RO,  fixed()"
                    # cdpCachePrimaryMgmtAddr 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.20.$i.1, OctetString, RO,  fixed()" 
                    # cdpCacheSecondaryMgmtAddrType 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.21.$i.1, Integer,      RO,  fixed()"
                    # cdpCacheSecondaryMgmtAddr 
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.22.$i.1, OctetString,  RO,  fixed()"
                    # cdpCachePhysLocation
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.23.$i.1, OctetString,  RO,  fixed(Lab)"
                    # cdpCacheLastChange      
                    puts $varChannel "1.3.6.1.4.1.9.9.23.1.2.1.1.24.$i.1, TimeTicks,    RO,  fixed(0)"
                }
            }
        }

        # Add the Cisco Memory Pool Table
        # ciscoMemoryPoolName     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.1, OctetString, RO, fixed(DRAM)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.6, OctetString, RO, fixed(FLASH)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.7, OctetString, RO, fixed(NVRAM)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.8, OctetString, RO, fixed(MBUF)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.9, OctetString, RO, fixed(CLUSTER)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.2.10, OctetString, RO, fixed(MALLOC)"
        # ciscoMemoryPoolAlternate    
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.1, Integer, RO, fixed(0)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.6, Integer, RO, fixed(0)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.7, Integer, RO, fixed(0)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.8, Integer, RO, fixed(0)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.9, Integer, RO, fixed(0)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.3.10, Integer, RO, fixed(0)"
        # ciscoMemoryPoolValid    
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.1, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.6, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.7, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.8, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.9, Integer, RO, fixed(1)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.4.10, Integer, RO, fixed(1)"
        # ciscoMemoryPoolUsed     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.1, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.6, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.7, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.8, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.9, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.5.10, Gauge  , RO, utilization(8, 2, 12)"
        # ciscoMemoryPoolFree     
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.1, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.6, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.7, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.8, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.9, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.6.10, Gauge  , RO, utilization(8, 2, 12)"
        # ciscoMemoryPoolLargestFree  
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.1, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.6, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.7, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.8, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.9, Gauge  , RO, utilization(8, 2, 12)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.7.10, Gauge  , RO, utilization(8, 2, 12)"
        # ciscoMemoryPoolLowMemoryNotifThreshold
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.1, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.6, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.7, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.8, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.9, Integer, RW, r_lastset(0, 100, 20)"
        puts $varChannel "1.3.6.1.4.1.9.9.48.1.1.1.8.10, Integer, RW, r_lastset(0, 100, 20)"
    }
}

###############################################################################
#
# Procedure:    TPG_genhostvarfile
# Input:        devID       Device I.D.
#               varChannel  Channel number of the var file being created
# Output:       New var file for a host
# Description:  This procedure creates a new var file for a host in the 
#               topology.
#
###############################################################################
proc TPG_genhostvarfile { devID varChannel } {
    global devices interfaces links cloneMap tokenTable

    if { $cloneMap } {
        set myIPAddr "\$\$MYIPADDRESS\$\$"
        set tokenTable($devID,0) 0      ;# Initialize token count
    } else {
        set myIPAddr $devices($devID,IPAddress)
    }

    # Add the System Name
    # sysName.0
    puts $varChannel "1.3.6.1.2.1.1.5.0             , OctetString , RW , r_lastset(0, 255, $devices($devID,systemName))"

    # Add the number of interfaces
    # ifNumber.0
    puts $varChannel "1.3.6.1.2.1.2.1.0             , Integer     , RO , fixed($devices($devID,maxInterfaces))"
    # Add the loopback interface
    # ifIndex.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.1.1         , Integer     , RO , fixed(1)"
    # ifDescr.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.2.1         , OctetString , RO , fixed(loopback)"
    # ifType.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.3.1         , Integer     , RO , fixed(24)"
    # ifMtu.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.4.1         , Integer     , RO , fixed()"
    # ifSpeed.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.5.1         , Gauge       , RO , fixed()"
    # ifPhysAddress.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.6.1         , OctetString , RO , fixed()"
    # ifAdminStatus.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.7.1         , Integer     , RW , r_lastset(1, 3, 1)"
    # ifOperStatus.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.8.1         , Integer     , RO , lastset(1)"
    # ifLastChange.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.9.1         , TimeTicks   , RO , fixed(0)"
    # ifInOctets.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.10.1        , Counter     , RO , randomup(0, 100)"
    # ifInUcastPkts.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.11.1        , Counter     , RO , randomup(0, 100)"
    # ifInNUcastPkts.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.12.1        , Counter     , RO , randomup(0, 100)"
    # ifInDiscards.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.13.1        , Counter     , RO , randomup(0, 0)"
    # ifInErrors.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.14.1        , Counter     , RO , randomup(0, 0)"
    # ifInUnknownProtos.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.15.1        , Counter     , RO , randomup(0, 100)"
    # ifOutOctets.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.16.1        , Counter     , RO , randomup(0, 100)"
    # ifOutUcastPkts.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.17.1        , Counter     , RO , randomup(0, 100)"
    # ifOutNUcastPkts.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.18.1        , Counter     , RO , randomup(0, 100)"
    # ifOutDiscards.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.19.1        , Counter     , RO , randomup(0, 0)"
    # ifOutErrors
    puts $varChannel "1.3.6.1.2.1.2.2.1.20.1        , Counter     , RO , randomup(0, 0)"
    # ifOutQLen.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.21.1        , Gauge       , RO , random(0, 100)"
    # ifSpecific.1
    puts $varChannel "1.3.6.1.2.1.2.2.1.22.1        , ObjectID    , RO , fixed(0.0)"

    # Add the Interfaces Table
    for { set i 2 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        # Get which end of the link this interface is, if any
        set linkEnd [TPG_getlinkend $i $devID]
        set linkEndID [lindex $linkEnd 0]
        set linkIndex [lindex $linkEnd 1]

        # ifIndex.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.1.$i         , Integer     , RO , fixed($i)"
        # ifDescr.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.2.$i         , OctetString , RO , fixed([getIfTypeValue [getIfType $devID $i] ifDescr])"
        # ifType.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.3.$i         , Integer     , RO , fixed([getIfType $devID $i])"
        # ifMtu.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.4.$i         , Integer     , RO , fixed([getIfTypeValue [getIfType $devID $i] ifMtu])"
        # ifSpeed.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.5.$i         , Gauge       , RO , fixed([getIfTypeValue [getIfType $devID $i] ifSpeed])"

        # ifPhysAddress.$i
        if [info exists interfaces($devID,$i,MACAddress)] {
            if { $cloneMap } {
                puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed("

                if { $interfaces($devID,$i,MACAddress) == $devices($devID,MACAddress) } {
                    puts -nonewline $varChannel "\$\$MYMAINMACADDR\$\$"
                } else {
                    # Save the value in the token table
                    incr tokenTable($devID,0)
                    set tokenTable($devID,$tokenTable($devID,0)) 0x$interfaces($devID,$i,MACAddress)

                    # Include token in var file
                    puts -nonewline $varChannel "\$\$MYTOKENS[format %03d $tokenTable($devID,0)]\$\$"
                }

                puts $varChannel ")"
            } else {
                puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed(0x$interfaces($devID,$i,MACAddress))"
            } 
        } else {
            puts $varChannel "1.3.6.1.2.1.2.2.1.6.$i         , OctetString , RO , fixed()"
        }

        # ifAdminStatus.$i 
        puts $varChannel "1.3.6.1.2.1.2.2.1.7.$i         , Integer     , RW , r_lastset(1, 3, 1)"

        # ifOperStatus.$i
        if { $linkEndID > 0 } { ;# This I/F is linked, set status to "up(1)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(1)"
        } else {                ;# This I/F is not linked, set status to "down(2)"
       	    puts $varChannel "1.3.6.1.2.1.2.2.1.8.$i         , Integer     , RO , lastset(2)"
        }

        # ifLastChange.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.9.$i         , TimeTicks   , RO , fixed(0)"
        # ifInOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.10.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.11.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.12.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifInDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.13.$i        , Counter     , RO , randomup(0, 0)"
        # ifInErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.14.$i        , Counter     , RO , randomup(0, 0)"
        # ifInUnknownProtos.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.15.$i        , Counter     , RO , randomup(0, 100)"
        # ifOutOctets.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.16.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum2),1000)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum1),1000)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.17.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum4),100)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum3),100)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutNUcastPkts.$i
        puts -nonewline $varChannel "1.3.6.1.2.1.2.2.1.18.$i        , Counter     , RO , "
        if { $linkEndID == 1 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum6),10)"
        } elseif { $linkEndID == 2 } {
            puts $varChannel "seqtimeinc($links($linkIndex,RandNum5),10)"
        } else {
            puts $varChannel "randomup(0,100)"
        }

        # ifOutDiscards.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.19.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutErrors.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.20.$i        , Counter     , RO , randomup(0, 0)"
        # ifOutQLen.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.21.$i        , Gauge       , RO , random(0, 100)"
        # ifSpecific.$i
        puts $varChannel "1.3.6.1.2.1.2.2.1.22.$i        , ObjectID    , RO , fixed(0.0)"
    }

    # Add the Address Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]

        if { $peerDevID != "" } {
            set ifArpList [TPG_getarpinfo $i $devID $peerDevID]
            foreach arpInfo $ifArpList {
                set macAddr [lindex $arpInfo 0]
                set ipAddr [lindex $arpInfo 1]

                if { $cloneMap } {
                    set macAddr [getToken $devID 0x$macAddr]
                    set ipAddr [getToken $devID $ipAddr]
                } else {
                    set macAddr 0x$macAddr
                }

                # atIfIndex
                puts $varChannel "1.3.6.1.2.1.3.1.1.1.$i.1.$ipAddr  , Integer   , RW , lastset($i)"
                # atPhysAddress
                puts $varChannel "1.3.6.1.2.1.3.1.1.2.$i.1.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
                # atNetAddress
                puts $varChannel "1.3.6.1.2.1.3.1.1.3.$i.1.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
            }
        }
    }

    # Add the IP Addr Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        if { [info exists interfaces($devID,$i,IPAddress)] && $interfaces($devID,$i,IPAddress) != "" } {
            # ipAdEntAddr
            puts $varChannel "1.3.6.1.2.1.4.20.1.1.$interfaces($devID,$i,IPAddress)     , IpAddress   , RO , fixed($interfaces($devID,$i,IPAddress))" 
            # ipAdEntIfIndex
            puts $varChannel "1.3.6.1.2.1.4.20.1.2.$interfaces($devID,$i,IPAddress)  , Integer     , RO , fixed($i)" 
            # ipAdEntNetMask
            puts $varChannel "1.3.6.1.2.1.4.20.1.3.$interfaces($devID,$i,IPAddress)  , IpAddress   , RO , fixed($interfaces($devID,$i,Mask))" 
            # ipAdEntBcastAddr
            puts $varChannel "1.3.6.1.2.1.4.20.1.4.$interfaces($devID,$i,IPAddress), Integer     , RO , fixed(1)" 
            # ipAdEntReasmMaxSize
            puts $varChannel "1.3.6.1.2.1.4.20.1.5.$interfaces($devID,$i,IPAddress), Integer     , RO , fixed(18024)" 
        }
    }

    set arpCacheList ""

    # Add the IP Net To Media Table
    for { set i 1 } { $i <= $devices($devID,maxInterfaces) } { incr i } {
        # Check for windowing events so the it doesn't appear frozen
        TPG_processwinevents

        set peerDevID [TPG_getpeer $i $devID]

        if { $peerDevID != "" } {
            set ifArpList [TPG_getarpinfo $i $devID $peerDevID]
            foreach arpInfo $ifArpList {
                set macAddr [lindex $arpInfo 0]
                set ipAddr [lindex $arpInfo 1]

                if { [TPG_chkdupinfo $arpCacheList $i.$ipAddr] == 1 } {
                    continue
                } else {
                    lappend arpCacheList $i.$ipAddr
                }

                if { $cloneMap } {
                    set macAddr [getToken $devID 0x$macAddr]
                    set ipAddr [getToken $devID $ipAddr]
                } else {
                    set macAddr "0x$macAddr"
                }

                # ipNetToMediaIfIndex
                puts $varChannel "1.3.6.1.2.1.4.22.1.1.$i.$ipAddr  , Integer   , RW , lastset($i)"
                # ipNetToMediaPhysAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.2.$i.$ipAddr  , OctetString   , RW , r_lastset(6, 6, $macAddr)"
                # ipNetToMediaNetAddress
                puts $varChannel "1.3.6.1.2.1.4.22.1.3.$i.$ipAddr  , IpAddress   , RW , lastset($ipAddr)"
                # ipNetToMediaType
                puts $varChannel "1.3.6.1.2.1.4.22.1.4.$i.$ipAddr  , Integer   , RW , r_lastset(1, 4, 3)"
            }
        }
    }

    # Add UDP Table
    # udpLocalAddress
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.0.0.0.0.67    , IpAddress   , RO , fixed(0.0.0.0)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.49, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.161, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.1919, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.4786, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.5461, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.6350, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7558, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.7879, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9768, IpAddress   , RO , fixed($myIPAddr)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.1.$myIPAddr.9968, IpAddress   , RO , fixed($myIPAddr)"
    # udpLocalPort
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.0.0.0.0.67       , Integer     , RO , fixed(67)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.49 , Integer     , RO , fixed(49)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.161, Integer     , RO , fixed(161)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.1919, Integer     , RO , fixed(1919)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.4786, Integer     , RO , fixed(4786)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.5461, Integer     , RO , fixed(5461)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.6350, Integer     , RO , fixed(6350)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7558, Integer     , RO , fixed(7558)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.7879, Integer     , RO , fixed(7879)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9768, Integer     , RO , fixed(9768)"
    puts $varChannel "1.3.6.1.2.1.7.5.1.2.$myIPAddr.9968, Integer     , RO , fixed(9968)"
}

###############################################################################
#
# Procedure:    TPG_updatestepdone
# Input:        None
# Output:       New step value for GUI
# Description:  This procedure increments the number of steps down and informs
#               the GUI to update the progress bar.
#               topology.
#
###############################################################################
proc TPG_updatestepsdone {} {
    global totalStepsDone

    incr totalStepsDone

    TPG_setstepsdone $totalStepsDone
}

###############################################################################
#
# Procedure:    TPG_genproject
# Input:        projName    Project name
#               xmlFilePath File Name of topology file (include directory path)
# Output:       Master precedure for generating the project files (Map file, 
#               cmf file, and var file)
# Description:  This procedure is called by the GUI to generate a map based on
#               a given topology file.
#
###############################################################################
proc TPG_genproject { projName xmlFilePath { cloneFlag 1 } { dirName ../projects } } {
    global devIDList totalStepsDone cancelGenMap cloneMap
    
    set totalStepsDone 0
    set cancelGenMap 0
    
    # Save cloneMap flag in global variable
    set cloneMap $cloneFlag
    
    # Read in the topology XML file
    TPG_readtopologyfile $xmlFilePath

    # Read in the ifType file
    TPG_readiftypefile

    # Set the total step for the progress bar. The total steps is based on
    # the number of devices (one for creating each var file and another for
    # sorting it) and one step for creating the map file.
    set totalSteps [expr [llength $devIDList] * 2 + 1]
    TPG_settotalsteps $totalSteps

    # Generate var files
    TPG_genvarfiles $projName $dirName

    # Set the message in the progress bar window
    TPG_updatestatustext "Creating Map File..."

    # Generate map file and increment the number of steps done.
    TPG_genmapfile $projName $xmlFilePath $dirName
    TPG_updatestepsdone

    # The project generation was aborted by the user. Send back a Tcl error
    # status.
    if { $cancelGenMap } {
        error "Map Generation Stopped." "Map Generation Stopped."
    }
}

