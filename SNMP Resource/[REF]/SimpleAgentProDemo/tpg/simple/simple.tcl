proc genTopology { projName params dirName varFileList cmfFileList telFileList } {
    global sortDone firstMacOctetHex firstMacOctetDec

    # Enable for testing on versions < 18.5
#   set dirName [file join .. projects]
    ###########################################################################
    # Extract the parameters
    ###########################################################################
    set numrouters [lindex $params 0]
    if { $numrouters > 254} {
        error "The number of routers must be less than 255"
    } elseif { $numrouters < 1 } {
        error "The number of routers must be greater than 0"
    }
    set numswitches [lindex $params 1]
    if { $numswitches > 254} {
        error "The number of switches must be less than 255"
    } elseif { $numswitches < 1 } {
        error "The number of switches must be greater than 0"
    }
    set numhosts [lindex $params 2]
    if { $numhosts > 254} {
        error "The number of hosts must be less than 255"
    } elseif { $numhosts < 5 } {
        error "The number of hosts must be greater than 4"
    }

    set numHostsPerVlan [lindex $params 3]
    if { $numHostsPerVlan > $numhosts } {
        error "The number of hosts per VLAN must not be greater than $numhosts"
    } elseif { $numHostsPerVlan < 1 } {
        error "The number of switches must be greater than 0"
    }

    set simhosts [lindex $params 4]
    if { $simhosts == "Yes" } {
        set supportHosts 1
    } elseif { $simhosts == "No" } {
        set supportHosts 0
    } else {
        error "Only Yes or No supported"
    }

    set seedip [lindex $params 5]
    set seedmac [lindex $params 6]
    set startip [lindex $params 7]
    if { [string is digit -strict $startip] == 0 } { ;# Make sure we have an integer
        error "The start sub-IP address must be an integer greater than 0 and less than 255"
    } elseif { $startip > 254} {
        error "The start sub-IP address must be less than 255"
    } elseif { $startip < 1 } {
        error "The start sub-IP address must be greater than 0"
    }

    # Extract the first octet from the seed Mac address
    set firstMacOctetHex [string range $seedmac 0 1]
    scan $firstMacOctetHex "%02x" firstMacOctetDec

    # Extract the var file templates
    set seedVarFile [lindex $varFileList 0]
    set routerVarFile [lindex $varFileList 1]
    set switchVarFile [lindex $varFileList 2]
    set hostVarFile [lindex $varFileList 3]

    # Extract the cmf files
    set seedCmfFile [lindex $cmfFileList 0]
    set routerCmfFile [lindex $cmfFileList 1]
    set switchCmfFile [lindex $cmfFileList 2]
    set hostCmfFile [lindex $cmfFileList 3]

    ###########################################################################
    # Extract subnet from seed IP addr
    ###########################################################################
    set seedipList [split $seedip "."]
    set seedipSubnet [lindex $seedipList 0].[lindex $seedipList 1].[lindex $seedipList 2]

    ###########################################################################
    # Determine number of steps for the progress bar
    ###########################################################################
    if { $supportHosts } {
        set totalDevices [expr 1 + $numrouters + ($numrouters * $numswitches) + ($numrouters * $numswitches * $numhosts)] 
    } else {
        set totalDevices [expr 1 + $numrouters + ($numrouters * $numswitches)] 
    }
    TPG_settotalsteps $totalDevices

    ###########################################################################
    # Generate the directories for the generated project
    ###########################################################################
    if { ![file exists [file join $dirName $projName]] } {
        file mkdir [file join $dirName $projName]
    }

    ###########################################################################
    # Setup the tpg variables
    ###########################################################################
    # Initialize seed router device ID
    set seedDevID 1

    # Initialize the next Device ID variable
    set nextDevID 0

    # Initialize the router coordinates. (Leaving a margin at the top and to 
    # the left
    set seedX 10
    set seedCrntY 10

    # Initialize the router coordinates.
    set rtrX 10
    set rtrCrntY 110

    # Initialize the switch coordinates
    set swX 10
    set swCrntY 10

    # Initialize the host coordinates, if needed
    set hostX 10
    set hostCrntY 10

    # Open the TPG file and link file for writing. It will initially contain 
    # the device definition and after building the list of devices, the link 
    # definition will be appended to the file.
    if { ![file exists [file join $dirName $projName tpg]] } {
        file mkdir [file join $dirName $projName tpg]
    }
    set tpgFile [open [file join $dirName $projName tpg ${projName}.tpg] w]
    set linkFile [open [file join $dirName $projName tpg zzz${projName}.link] w+]

    # Write the header lines for the tpg file
    puts $tpgFile "<!DOCTYPE TopologyDocument>"
    puts $tpgFile "<Doc>"
    puts $tpgFile " <DeviceList>"

    # Write the header line for the link list
    puts $linkFile " <LinkList>"

    ###########################################################################
    # Create the var directory. Update and copy the var files to directory.
    ###########################################################################
    if { ![file exists [file join $dirName $projName var]] } {
        file mkdir [file join $dirName $projName var]
    }

    # Build the host var file, if supported
    if { $supportHosts } {
        set inFileName $hostVarFile

        if { [string first "host1.var" "$hostVarFile"] > 0 } {  ;# Use the default var file
            set outFileName [file join $dirName $projName var host1.var]
            file copy -force -- $inFileName $outFileName
        } else {    ;# Use the user's var file as a starting point and added the required tables
            set tmpFileName [file join $dirName $projName var host1.tmp]
            set varFilterName [file join .. tpg simple host1.flt]

            # Let vfilter run in background so we can check for windowing events
            set sortDone 0

            set filterPipe [open "|../bin/sapvfilter \"$inFileName\" $tmpFileName $varFilterName \"$hostCmfFile\""]
            if { $filterPipe <= 0 } {
                error "Filter Failed for $hostVarFile"
            }
            fileevent $filterPipe readable [list checkforEOF $filterPipe]
            vwait sortDone; # Wait here in the Tcl event loop until vfilter is done
        
            # Merge the new MIB objected with the filtered file
            set mergeFile [file join .. tpg simple host1_tmplt.var]
            set resFile [file join $dirName $projName var host1_2.tmp]
            mergeFiles $tmpFileName $mergeFile $resFile
            file delete $tmpFileName

            # Let vsort run in background so we can check for windowing events
            set tmpFileName0 [file join $dirName $projName var host1_3.tmp]
            set sortDone 0
            set sortPipe [open "|../bin/sapvsort $resFile \"$hostCmfFile\" $tmpFileName0"]
            if { $sortPipe <= 0 } {
                error "Sort Failed for $varFileName"
            }
            fileevent $sortPipe readable [list checkforEOF $sortPipe]
            vwait sortDone; # Wait here in the Tcl event loop until vsort is done
        
            # Merge header file with new sorted file
            set varFileName [file join $dirName $projName var host1.var]
            set hdrFileName [file join .. tpg simple host1.hdr]
            mergeFiles $hdrFileName $tmpFileName0 $varFileName

            # Copy the filtered file to the scratch file
            file delete $tmpFileName0
            file delete $resFile
        }
    }

    # Build the seed1.var file
    if { [string first "seed1.var" "$seedVarFile"] > 0 } {  ;# Use the default file
        set updateList [list [list STARTIP_DEC $startip]]
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numrouters + 1]]
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        updateSapDefines $updateList $seedVarFile [file join $dirName  $projName var seed1.var]
    } else {    ;# Use the user's var file as a starting point and add the required tables
        set tmpFileName [file join $dirName $projName var seed1.tmp]
        set varFilterName [file join .. tpg simple seed1.flt]

        # Let vfilter run in background so we can check for windowing events
        set sortDone 0

        set filterPipe [open "|../bin/sapvfilter \"$seedVarFile\" $tmpFileName $varFilterName \"$seedCmfFile\""]
        if { $filterPipe <= 0 } {
            error "Filter Failed for $seedVarFile"
        }
        fileevent $filterPipe readable [list checkforEOF $filterPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vfilter is done
    
        # Merge the new MIB objected with the filtered file
        set mergeFile [file join .. tpg simple seed1_tmplt.var]
        set resFile [file join $dirName $projName var seed1_2.tmp]
        mergeFiles $tmpFileName $mergeFile $resFile
        file delete $tmpFileName

        # Let vsort run in background so we can check for windowing events
        set tmpFileName0 [file join $dirName $projName var seed1_3.tmp]
        set sortDone 0
        set sortPipe [open "|../bin/sapvsort $resFile \"$seedCmfFile\" $tmpFileName0"]
        if { $sortPipe <= 0 } {
            error "Sort Failed for $varFileName"
        }
        fileevent $sortPipe readable [list checkforEOF $sortPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vsort is done
    
        # Merge header file with new sorted file
        set varFileName [file join $dirName $projName seed1.var]
        set hdrFileName [file join .. tpg simple seed1.hdr]
        mergeFiles $hdrFileName $tmpFileName0 $varFileName

        # Copy the filtered file to the scratch file
        file delete $tmpFileName0
        file delete $resFile

        set updateList [list [list STARTIP_DEC $startip]]
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numrouters + 1]]
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        updateSapDefines $updateList $varFileName [file join $dirName  $projName var seed1.var]

        file delete $varFileName
    }

    # Build the router1.var file
    if { [string first "router1.var" "$routerVarFile"] >= 0 } { ;# Use the default var file
        set updateList [list [list STARTIP_DEC $startip]]
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numswitches + 1]]
        lappend updateList [list NUM_HIFS [expr $numhosts + 2]]
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        set inFileName $routerVarFile
        set outFileName [file join $dirName $projName var router1.var]
        updateSapDefines $updateList $inFileName $outFileName

        set inFile [open $outFileName r]
        set outFile [open temp.var w+]

        #
        # update the router.var for arp cache info related to interfaces
        #
        # For each line in the source file look for the OLD and NEW ARP CACHE
        while {[gets $inFile line] >= 0} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents

            # Check to see if the current line is the old arp cache table
            if { [string first "#OldARPCacheInterfaceSpecificEntries" $line] >= 0 } {
                puts $outFile $line
                for {set i 2} { $i <= [expr $numswitches + 1] } { incr i} {
                    set hexpid  [format "%02x" $i]
                    puts $outFile "#"
                    puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.1     , OctetString  , RO , indexstr(15, 0, 0x${firstMacOctetHex}03\$\$MYTOKENS002\$\$%02x0101)"
                    puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.2     , OctetString  , RO , indexstr(15, 0, 0x${firstMacOctetHex}02\$\$MYTOKENS002\$\$0101${hexpid})"
                    puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.\[3-NUM_HIFS\]  , OctetString  , RO , indexstr(15, 2, 0x${firstMacOctetHex}04\$\$MYTOKENS002\$\$${hexpid}%02x01)"
                }
            } elseif { [string first "#NewARPCacheInterfaceSpecificEntries" $line] >= 0 } {
                puts $outFile $line
                for {set i 2} { $i <= [expr $numswitches + 1] } { incr i} {
                    set hexpid  [format "%02x" $i]
                    puts $outFile "#"
                    puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.1      , OctetString  , RO , indexstr(14, 0, 0x${firstMacOctetHex}03\$\$MYTOKENS002\$\$%02x0101)"
                    puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.2      , OctetString  , RO , indexstr(14, 0, 0x${firstMacOctetHex}02\$\$MYTOKENS002\$\$0101${hexpid})"
                    puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.\[3-NUM_HIFS\]  , OctetString  , RO , indexstr(14, 2, 0x${firstMacOctetHex}04\$\$MYTOKENS002\$\$${hexpid}%02x01)"
                }
            } else {
                # Write the line out to the target file
                puts $outFile $line
            }
        }
        close $inFile
        close $outFile
        file copy -force temp.var $outFileName
        file delete -force temp.var

    } else {    ;# Use the user's var file as a starting point and add the required tables
        set tmpFileName [file join $dirName $projName var router1.tmp]
        set varFilterName [file join .. tpg simple router1.flt]

        # Let vfilter run in background so we can check for windowing events
        set sortDone 0

        set filterPipe [open "|../bin/sapvfilter \"$routerVarFile\" $tmpFileName $varFilterName \"$routerCmfFile\""]
        if { $filterPipe <= 0 } {
            error "Filter Failed for $routerVarFile"
        }
        fileevent $filterPipe readable [list checkforEOF $filterPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vfilter is done
    
        # Merge the new MIB objected with the filtered file
        set mergeFile [file join .. tpg simple router1_tmplt.var]
        set resFile [file join $dirName $projName var router1_2.tmp]
        mergeFiles $tmpFileName $mergeFile $resFile
        file delete $tmpFileName

        # Add the arp cache to the var file
        set outFile [open $resFile a+]

        # Old ARP table
        for {set i 2} { $i <= [expr $numswitches + 1] } { incr i} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents
            
            set hexpid  [format "%02x" $i]
            puts $outFile "#"
            puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.1     , OctetString  , RO , indexstr(15, 0, 0x${firstMacOctetHex}03\$\$MYTOKENS002\$\$%02x0101)"
            puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.2     , OctetString  , RO , indexstr(15, 0, 0x${firstMacOctetHex}02\$\$MYTOKENS002\$\$0101${hexpid})"
            puts $outFile "1.3.6.1.2.1.3.1.1.2.$i.1.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.\[3-NUM_HIFS\]  , OctetString  , RO , indexstr(15, 2, 0x${firstMacOctetHex}04\$\$MYTOKENS002\$\$${hexpid}%02x01)"
        }

        # New ARP table
        for {set i 2} { $i <= [expr $numswitches + 1] } { incr i} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents

            set hexpid  [format "%02x" $i]
            puts $outFile "#"
            puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.1      , OctetString  , RO , indexstr(14, 0, 0x${firstMacOctetHex}03\$\$MYTOKENS002\$\$%02x0101)"
            puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.2      , OctetString  , RO , indexstr(14, 0, 0x${firstMacOctetHex}02\$\$MYTOKENS002\$\$0101${hexpid})"
            puts $outFile "1.3.6.1.2.1.4.22.1.2.$i.STARTIP_DEC.\$\$MYTOKENS001\$\$.$i.\[3-NUM_HIFS\]  , OctetString  , RO , indexstr(14, 2, 0x${firstMacOctetHex}04\$\$MYTOKENS002\$\$${hexpid}%02x01)"
        }
        close $outFile

        # Let vsort run in background so we can check for windowing events
        set tmpFileName0 [file join $dirName $projName var router1_3.tmp]
        set sortDone 0
        set sortPipe [open "|../bin/sapvsort $resFile \"$routerCmfFile\" $tmpFileName0"]
        if { $sortPipe <= 0 } {
            error "Sort Failed for $varFileName"
        }
        fileevent $sortPipe readable [list checkforEOF $sortPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vsort is done
    
        # Merge header file with new sorted file
        set varFileName [file join $dirName $projName router1.var]
        set hdrFileName [file join .. tpg simple router1.hdr]
        mergeFiles $hdrFileName $tmpFileName0 $varFileName

        # Copy the filtered file to the scratch file
        file delete $tmpFileName0
        file delete $resFile

        set updateList [list [list STARTIP_DEC $startip]]
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numswitches + 1]]
        lappend updateList [list NUM_HIFS [expr $numhosts + 2]]
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        set outFileName [file join $dirName $projName var router1.var]
        updateSapDefines $updateList $varFileName $outFileName

        file delete $varFileName
    }

    # Build the switch1.var file
    if { [string first "switch1.var" "$switchVarFile"] >= 0 } { ;# Use the default var file
        set updateList [list [list STARTIP_DEC $startip]] 
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numhosts + 1]]
        if { [expr $numhosts % 5] > 0 } {
            set partial 1
        } else {
            set partial 0
        }
        lappend updateList [list NUMVLANS [expr ($numhosts / 5) + $partial]]
        lappend updateList [list NUM_HIFS [expr $numhosts + 2]]
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        set inFileName $switchVarFile
        set outFileName [file join $dirName $projName var switch1.var]
        updateSapDefines $updateList $inFileName $outFileName

        set inFile [open $outFileName r]
        set outFile [open temp.var w+]
        #
        # update the switch.var for vlan info
        #
        # For each line in the source file look for the VLAN Port Table
        while {[gets $inFile line] >= 0} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents

            # Check to see if the current line is the VLAN port table
            if { [string first "VLAN port table" $line] >= 0 } {
                puts $outFile $line
                puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.1.1.\[1-NUMIFS\],        Integer,      RO,  fixed(1)"
                puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.2.1.\[1-NUMIFS\],        Integer,      RO,  indexvalue(0)"
    
                set vlanNum 1
                for {set hosts [expr $numhosts]} {$hosts > 0} {incr hosts -$numHostsPerVlan} {
                    set startRange [expr (($vlanNum - 1) * $numHostsPerVlan) + 2]
                    set endRange [expr $startRange + ($numHostsPerVlan - 1)]
                    if { $endRange > [expr $numhosts + 1] } {
                        set endRange [expr $numhosts + 1]
                    }

                    if { $endRange > $startRange } {
                        puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.3.1.\[$startRange-$endRange\], Integer, RO, fixed($vlanNum)"
                    } else {
                        puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.3.1.$endRange, Integer, RO, fixed($vlanNum)"
                    }
    
                    incr vlanNum
                }
             } else {
                # Write the line out to the target file
                puts $outFile $line
            }
        }
    
        close $inFile
        close $outFile

        file copy -force temp.var $outFileName
        file delete -force temp.var
    } else {    ;# Use the user's var file as a starting point and add the required tables
        set tmpFileName [file join $dirName $projName var switch1.tmp]
        set varFilterName [file join .. tpg simple switch1.flt]

        # Let vfilter run in background so we can check for windowing events
        set sortDone 0

        set filterPipe [open "|../bin/sapvfilter \"$switchVarFile\" $tmpFileName $varFilterName \"$switchCmfFile\""]
        if { $filterPipe <= 0 } {
            error "Filter Failed for $switchVarFile"
        }
        fileevent $filterPipe readable [list checkforEOF $filterPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vfilter is done
    
        # Merge the new MIB objected with the filtered file
        set mergeFile [file join .. tpg simple switch1_tmplt.var]
        set resFile [file join $dirName $projName var switch1_2.tmp]
        mergeFiles $tmpFileName $mergeFile $resFile
        file delete $tmpFileName

        # Add the VLAN Port Table
        set outFile [open $resFile a+]

        puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.1.1.\[1-NUMIFS\],        Integer,      RO,  fixed(1)"
        puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.2.1.\[1-NUMIFS\],        Integer,      RO,  indexvalue(0)"
    
        set vlanNum 1
        for {set hosts [expr $numhosts]} {$hosts > 0} {incr hosts -$numHostsPerVlan} {
            set startRange [expr (($vlanNum - 1) * $numHostsPerVlan) + 2]
            set endRange [expr $startRange + ($numHostsPerVlan - 1)]
            if { $endRange > [expr $numhosts + 1] } {
                set endRange [expr $numhosts + 1]
            }

            if { $endRange > $startRange } {
                puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.3.1.\[$startRange-$endRange\], Integer, RO, fixed($vlanNum)"
            } else {
                puts $outFile "1.3.6.1.4.1.9.5.1.9.3.1.3.1.$endRange, Integer, RO, fixed($vlanNum)"
            }
    
            incr vlanNum
        }
        close $outFile

        # Let vsort run in background so we can check for windowing events
        set tmpFileName0 [file join $dirName $projName var switch1_3.tmp]
        set sortDone 0
        set sortPipe [open "|../bin/sapvsort $resFile \"$switchCmfFile\" $tmpFileName0"]
        if { $sortPipe <= 0 } {
            error "Sort Failed for $varFileName"
        }
        fileevent $sortPipe readable [list checkforEOF $sortPipe]
        vwait sortDone; # Wait here in the Tcl event loop until vsort is done
    
        # Merge header file with new sorted file
        set varFileName [file join $dirName $projName switch1.var]
        set hdrFileName [file join .. tpg simple switch1.hdr]
        mergeFiles $hdrFileName $tmpFileName0 $varFileName

        # Copy the filtered file to the scratch file
        file delete $tmpFileName0
        file delete $resFile

        set updateList [list [list STARTIP_DEC $startip]] 
        lappend updateList [list STARTIP_HEX [format "%02x" $startip]]
        lappend updateList [list NUMIFS [expr $numhosts + 1]]
        if { [expr $numhosts % 5] > 0 } {
            set partial 1
        } else {
            set partial 0
        }
        lappend updateList [list STARTMAC_HEX $firstMacOctetHex]
        lappend updateList [list STARTMAC_DEC $firstMacOctetDec]
        lappend updateList [list NUMVLANS [expr ($numhosts / $numHostsPerVlan) + $partial]]
        set inFileName $switchVarFile
        set outFileName [file join $dirName $projName var switch1.var]
        updateSapDefines $updateList $varFileName $outFileName

        file delete $varFileName
    }

    # Add the VLANs' MIB variables to the switch1.var file
    if { $numhosts > $numHostsPerVlan } {
        set outFile [open $outFileName a+]

        set vlanNum 2
        for {set hosts [expr $numhosts - $numHostsPerVlan]} {$hosts > 0} {incr hosts -$numHostsPerVlan} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents

            puts $outFile "#"
            puts $outFile "# vlan $vlanNum"
            puts $outFile "#"
            puts $outFile "%csibegin 1.3.6.1.2.1.17 2 vlan-$vlanNum"
            puts $outFile "#bridge mib 1.3.6.1.2.1.17"
            puts $outFile "1.3.6.1.2.1.17.1.1.0         ,   OctetString,   RO, fixed(1.4.\$\$MYTOKENS001\$\$.7.1.2)"
            puts $outFile "1.3.6.1.2.1.17.1.2.0         ,   Integer,       RO, fixed(3)"
            puts $outFile "1.3.6.1.2.1.17.1.3.0         ,   Integer,       RO, fixed(2)"
            puts $outFile "# Bridge Port Table"
            puts $outFile "# Index: Bridge port number"

            set startRange [expr (($vlanNum - 1) * $numHostsPerVlan) + 2]
            set endRange [expr $startRange + ($numHostsPerVlan - 1)]
            if { $endRange > [expr $numhosts + 1] } {
                set endRange [expr $numhosts + 1]
            }
            if { $endRange > $startRange } {
                puts $outFile "1.3.6.1.2.1.17.1.4.1.1.\[$startRange-$endRange\] ,   Integer,  RO, indexvalue(0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.2.\[$startRange-$endRange\] ,   Integer,  RO, indexvalue(0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.3.\[$startRange-$endRange\] ,   ObjectID, RO, fixed(0.0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.4.\[$startRange-$endRange\] ,   Counter,  RO, randomup(0, 100)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.5.\[$startRange-$endRange\] ,   Counter,  RO, randomup(0, 100)"
                puts $outFile "# forwarding database"
                puts $outFile "# Index: MAC address"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.1.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.\[$startRange-$endRange\].1 , OctetString , RO , indexstr(15,0,0x${firstMacOctetHex}04\$\$MYTOKENS004\$\$%02x01)"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.2.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.\[$startRange-$endRange\].1 , Integer     , RO , indexvalue(15)"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.3.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.\[$startRange-$endRange\].1 , Integer     , RO , fixed(3)"
            } else {
                puts $outFile "1.3.6.1.2.1.17.1.4.1.1.$endRange ,   Integer,  RO, indexvalue(0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.2.$endRange ,   Integer,  RO, indexvalue(0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.3.$endRange ,   ObjectID, RO, fixed(0.0)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.4.$endRange ,   Counter,  RO, randomup(0, 100)"
                puts $outFile "1.3.6.1.2.1.17.1.4.1.5.$endRange ,   Counter,  RO, randomup(0, 100)"
                puts $outFile "# forwarding database"
                puts $outFile "# Index: MAC address"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.1.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.$endRange.1 , OctetString , RO , indexstr(15,0,0x${firstMacOctetDec}04\$\$MYTOKENS004\$\$[format %02x $endRange]01)"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.2.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.$endRange.1 , Integer     , RO , indexvalue(15)"
                puts $outFile "1.3.6.1.2.1.17.4.3.1.3.${firstMacOctetDec}.4.\$\$MYTOKENS003\$\$.$endRange.1 , Integer     , RO , fixed(3)"
            }

            puts $outFile "%csiend"

            incr vlanNum
        }

        close $outFile
    }

    ###########################################################################
    # Create the cmf directory. Copy cmf files to directory
    ###########################################################################
    if { ![file exists [file join $dirName $projName cmf]] } {
        file mkdir [file join $dirName $projName cmf]
    }

    set cmfFile [lindex $cmfFileList 0]
    set fileName [file tail $cmfFile]
    set seedCmfFile [file join $dirName  $projName cmf $fileName] 
    file copy -force -- $cmfFile $seedCmfFile

    set cmfFile [lindex $cmfFileList 1]
    set fileName [file tail $cmfFile]
    set routerCmfFile [file join $dirName  $projName cmf $fileName] 
    file copy -force -- $cmfFile $routerCmfFile

    set cmfFile [lindex $cmfFileList 2]
    set fileName [file tail $cmfFile]
    set switchCmfFile [file join $dirName  $projName cmf $fileName] 
    file copy -force -- $cmfFile $switchCmfFile

    set cmfFile [lindex $cmfFileList 3]
    set fileName [file tail $cmfFile]
    set hostCmfFile [file join $dirName  $projName cmf $fileName] 
    file copy -force -- $cmfFile $hostCmfFile

    # Copy telnet files to directory
    if { ![file exists [file join $dirName $projName telnet]] } {
        file mkdir [file join $dirName $projName telnet]
    }

    ###########################################################################
    # Iterate thru the Telnet Modeling File list and determine which
    # devices have Telnet enabled. NOTE: the list is order dependent, which
    # is -- Seed1, Route, Switch, and Host
    ###########################################################################
    set position 1
    foreach telFile $telFileList {
        # Process any pending windowing events so that the GUI can be updated
        TPG_processwinevents

        set fileName [file tail $telFile]
        set rootName [file rootname $fileName]
        if { $rootName != "None" } {
            set telModelingFile [file join $dirName  $projName telnet $fileName] 
            file copy -force -- $telFile $telModelingFile

            if { $position == 1 } {         ;# Save the Seed1 Telnet Modeling File
                set telSeed1Name $telModelingFile
            } elseif { $position == 2 } {  ;# Save the Router Telnet Modeling File
                set telRouterName $telModelingFile
            } elseif { $position == 3 } {  ;# Save the Switch Telnet Modeling File
                set telSwitchName $telModelingFile
            } else {                        ;# Save the Host Telnet Modeling File
                set telHostName $telModelingFile
            }
        } else {
            if { $position == 1 } {         ;# Clear the Seed1 Telnet Modeling File
                set telSeed1Name $rootName
            } elseif { $position == 2 } {  ;# Clear the Router Telnet Modeling File
                set telRouterName $rootName
            } elseif { $position == 3 } {  ;# Clear the Switch Telnet Modeling File
                set telSwitchName $rootName
            } else {                        ;# Clear the Host Telnet Modeling File
                set telHostName $rootName
            }
        }
        incr position
    }

    ###########################################################################
    # Create all the rest of the directories for the probject
    ###########################################################################
    if { ![file exists [file join $dirName $projName log]] } {
        file mkdir [file join $dirName $projName log]
    }

    if { ![file exists [file join $dirName $projName scenarios]] } {
        file mkdir [file join $dirName $projName scenarios]
    }

    if { ![file exists [file join $dirName $projName tcl]] } {
        file mkdir [file join $dirName $projName tcl]
    }

    if { ![file exists [file join $dirName $projName tl1]] } {
        file mkdir [file join $dirName $projName tl1]
    }

    if { ![file exists [file join $dirName $projName http]] } {
        file mkdir [file join $dirName $projName http]
    }

    set mapDir [file join $dirName $projName map] 
    if { ![file exists $mapDir] } {
        file mkdir $mapDir 
    }
    
    # Setup path for topo images file
    set imgPath [file join .. images saptopo]

    # Setup path for var file
    set varPath [file join $dirName $projName var]

    # Setup path for cmf file
    set cmfPath [file join $dirName $projName cmf]

    ###########################################################################
    # Generate the contents of the map file and tpg file.
    ###########################################################################
    # check if the map needs to be optimized
    set curMapExt   1
    if {$supportHosts} {
        set estTotalDev [expr 1 + $numrouters * $numswitches * $numhosts ]
    } else {
        set estTotalDev [expr 1 + $numrouters * $numswitches ]
    }

    # open the map file
    if {$estTotalDev > 100} {
        set mapChannel [open [file join $mapDir ${projName}_${curMapExt}.map] w+]

        # Initialize mapList with first map
        set mapList [file join $mapDir ${projName}_${curMapExt}.map]
    } else {
        set mapChannel [open [file join $mapDir ${projName}.map] w+]

        # Initialize mapList with first and only map
        set mapList [file join $mapDir ${projName}.map]
    }

    if { $mapChannel == -1 } {
        return 1;   # Could not open map file for writing
    }

    # initialize the current device count
    set curDevCount 0

    # Set the message in the progress bar window
    TPG_updatestatustext "Creating Map File(s)..."

    ###########################################################################
    # Add the seed router to the map
    puts $mapChannel "<DeviceMap"
    puts $mapChannel "    Release = \"11.0\""
    set timeStamp [clock format [clock seconds] -format "%D %T"]
    puts $mapChannel "    Description = \"SAPro Generated Map -- $timeStamp\""
    puts $mapChannel "    UserData = \"\""
    puts $mapChannel "    SetupFile = \"\""
    puts $mapChannel "    Interface = \"\""
    puts $mapChannel "    Separator = \"\""
    puts $mapChannel "    StartInterfaceNum = \"0\""

    # Only include TPG file in map if total number of devices is less than 1000
    if { $totalDevices <= 1000 } {
        puts $mapChannel "    TPGFilePath = \"[file nativename [file join $dirName $projName tpg $projName.tpg]]\""
    }

    puts $mapChannel "    Username = \"SAProGenMap\">"

    # Set the message in the progress bar window
    TPG_updatestatustext "$seedip"

    # first add the seed router
    puts $mapChannel "    <Device"
    puts $mapChannel "        <General"
    puts $mapChannel "            Name = \"$seedip\""
    puts $mapChannel "            MultiHome = \"1\""
    puts $mapChannel "            DHCP = \"0\""
    puts $mapChannel "            SubnetMask = \"255.255.255.0\""
    puts $mapChannel "            MacAddress = \"$seedmac\""
    puts $mapChannel "            Interface = \"\""
    puts $mapChannel "            UserData = \"\""
    puts $mapChannel "            TopologyData = \"$seedipSubnet\""
    puts $mapChannel "            DisplayTag = \"seed_router\""
    puts $mapChannel "            DisplayLogo = \"[file nativename [file join $imgPath router.bmp]]\""
    puts $mapChannel "            ModelingFile = \"\""
    puts $mapChannel "        />"
    puts $mapChannel "        <Snmp"
    puts $mapChannel "            ReadCommunity = \"public\""
    puts $mapChannel "            WriteCommunity = \"private\""
    puts $mapChannel "            MibFile = \"[file nativename $seedCmfFile]\""
    puts $mapChannel "            AgentFile = \"[file nativename [file join $varPath seed1.var]]\""
    puts $mapChannel "            TrapMgr = \"\""
    puts $mapChannel "            ResponseDelay = \"0\""
    puts $mapChannel "            SnmpStr = \"V1V2V3\""
    puts $mapChannel "            MtuSize = \"1500\""
    puts $mapChannel "            SnmpPort = \"161\""
    puts $mapChannel "            SecurityLevel = \"NoAuthNoPriv\""
    puts $mapChannel "        />"
    if { $telSeed1Name != "None" } {
        puts $mapChannel "        <Telnet"
        puts $mapChannel "            TelnetPort = \"23\""
        puts $mapChannel "            TelnetFile = \"$telSeed1Name\""
        puts $mapChannel "        />"
    }
#   puts $mapChannel "        <SSH"
#   puts $mapChannel "            SSHUserName = \"qatester\""
#   puts $mapChannel "            SSHPassword = \"qadevice\""
#   puts $mapChannel "            SSHSCPBaseDir = \"\/tmp\""
#   puts $mapChannel "            SSHVersion = \"SSH-1.99-SSHSAPRO-4.3\""
#   puts $mapChannel "            SSHFile =  \"CiscoCat3750-SwRtr-Work.tel\""
#   puts $mapChannel "        />"
    puts $mapChannel "    />"

    set rtrDevID [incr nextDevID]
    # Add the seed router's coordinates and ID to the tpg device list
    puts $tpgFile "  <Device x=\"$seedX\" y=\"$seedCrntY\" Type=\"0\" ID=\"$rtrDevID\" >"

    # Add the seed router's device properties
    puts -nonewline $tpgFile "   <DeviceProperties telnetModelingFile=\""
    if { $telSeed1Name != "None" } {
        puts -nonewline $tpgFile $telSeed1Name
    }
    puts -nonewline $tpgFile "\" MACAddress=\"$seedmac\" snmpEnabled=\"YES\" tclModelingFile=\"\" "
    puts -nonewline $tpgFile "IPAddress=\"$seedip\" vendorVarName=\"\" cmfName=\"[file nativename $seedCmfFile]\" "
    puts -nonewline $tpgFile "userDefinedCmfVar=\"YES\" maxInterfaces=\"$numrouters\" "
    puts -nonewline $tpgFile "vendorLogo=\"[file nativename [file join $imgPath router.bmp]]\" "
    puts -nonewline $tpgFile "vendorName=\"No Device Selected\" systemName=\"seed_router\" subnet=\""
    puts -nonewline $tpgFile "$seedipSubnet\" vendorCmfName=\"\" telnetPort=\"23\" mask=\""
    puts -nonewline $tpgFile "255.255.255.0\" telnetEnabled=\" "
    if { $telSeed1Name != "None" } {
        puts -nonewline $tpgFile "YES"
    } else {
        puts -nonewline $tpgFile "NO"
    }
    puts $tpgFile "\" varName=\"[file nativename [file join $varPath seed1.var]]\" /> "

    # Add the seed router's interface list
    puts $tpgFile "   <InterfaceList>"
    puts -nonewline $tpgFile "    <Interface MACAddress=\"$seedmac\" IPAddress=\"$seedip\" "
    puts            $tpgFile "InterfaceNumber=\"1\" Mask=\"255.255.255.0\" />" 
    for {set i 1} {$i <= $numrouters} {incr i} {
        set indxDec [expr $i + 1]
        set indxHex [format "%02x" $indxDec]
        puts -nonewline $tpgFile "    <Interface MACAddress=\"${firstMacOctetHex}01010101${indxHex}\" "
        puts -nonewline $tpgFile "InterfaceNumber=\"$indxDec\" "
        puts $tpgFile "IPAddress=\"$startip.1.$indxDec.2\" Mask=\"255.255.255.0\" />" 
    }
    puts $tpgFile "   </InterfaceList>"
    puts $tpgFile "  </Device>"
 
    # Finished with the seed router so increment the device count
    incr curDevCount

    # Tell the GUI that we are done
    TPG_setstepsdone

    # Now add the routers
    for {set i 0} { $i < $numrouters } { incr i} {
        # Process any pending windowing events so that the GUI can be updated
        TPG_processwinevents

        set rtrOwnIndxDec [expr $i + 1]
        set rtrOwnIndxHex [format "%02x" $rtrOwnIndxDec]
        set rtrIndxDec [expr $i + 2]
        set rtrIndxHex [format "%02x" $rtrIndxDec]

        # check for optimization
        if {$curDevCount >= 100} {
            puts $mapChannel "</DeviceMap>"
            close $mapChannel
            incr curMapExt
            set mapChannel [open [file join $mapDir ${projName}_${curMapExt}.map] w+]
            if { $mapChannel == -1 } {
                return 1;   # Could not open map file for writing
            }

            # Add the map to the list
            lappend mapList [file join $mapDir ${projName}_${curMapExt}.map]

            puts $mapChannel "<DeviceMap"
            puts $mapChannel "    Release = \"11.0\""
            set timeStamp [clock format [clock seconds] -format "%D %T"]
            puts $mapChannel "    Description = \"SAPro Generated Map -- $timeStamp\""
            puts $mapChannel "    UserData = \"\""
            puts $mapChannel "    SetupFile = \"\""
            puts $mapChannel "    Interface = \"\""
            puts $mapChannel "    Separator = \"\""
            puts $mapChannel "    StartInterfaceNum = \"0\""

            # Only point to the TPG file if it contain less than 1000 devices
            if { $totalDevices <= 1000 } {
                puts $mapChannel "    TPGFilePath = \"[file nativename [file join $dirName $projName tpg $projName.tpg]]\""
            }

            puts $mapChannel "    Username = \"SAProGenMap\">"
            set curDevCount 0
        }

        set rwid     [expr $i + 2]
        set rdid     [expr $i + 1]
        set hexrwid  [format "%02x" $rwid]
        set devip    $startip.1.$rwid.1
        set crouter  $devip
        set devmac   ${firstMacOctetHex}020101${hexrwid}01
        set tokens   "$rwid,$hexrwid"
        set varfile  "[file nativename [file join $varPath router1.var]]"
        
        # Set the message in the progress bar window
        TPG_updatestatustext "$devip"

        # now add the device record for each line
        puts $mapChannel "    <Device"
        puts $mapChannel "        <General"
        puts $mapChannel "            Name = \"$devip\""
        puts $mapChannel "            MultiHome = \"1\""
        puts $mapChannel "            DHCP = \"0\""
        puts $mapChannel "            SubnetMask = \"255.255.255.0\""
        puts $mapChannel "            MacAddress = \"$devmac\""
        puts $mapChannel "            Interface = \"\""
        puts $mapChannel "            UserData = \"\""
        puts $mapChannel "            TopologyData = \"$tokens\""
        puts $mapChannel "            DisplayTag = \"router_${rdid}\""
        puts $mapChannel "            DisplayLogo = \"[file nativename [file join $imgPath router.bmp]]\""
        puts $mapChannel "            ModelingFile = \"\""
        puts $mapChannel "        />"
        puts $mapChannel "        <Snmp"
        puts $mapChannel "            ReadCommunity = \"public\""
        puts $mapChannel "            WriteCommunity = \"private\""
        puts $mapChannel "            MibFile = \"[file nativename $routerCmfFile]\""
        puts $mapChannel "            AgentFile = \"$varfile\""
        puts $mapChannel "            TrapMgr = \"\""
        puts $mapChannel "            ResponseDelay = \"0\""
        puts $mapChannel "            SnmpStr = \"V1V2V3\""
        puts $mapChannel "            MtuSize = \"1500\""
        puts $mapChannel "            SnmpPort = \"161\""
        puts $mapChannel "            SecurityLevel = \"NoAuthNoPriv\""
        puts $mapChannel "        />"
        if { $telRouterName != "None" } {
            puts $mapChannel "        <Telnet"
            puts $mapChannel "            TelnetPort = \"23\""
            puts $mapChannel "            TelnetFile = \"$telRouterName\""
            puts $mapChannel "        />"
        }
#       puts $mapChannel "        <SSH"
#       puts $mapChannel "            SSHUserName = \"qatester\""
#       puts $mapChannel "            SSHPassword = \"qadevice\""
#       puts $mapChannel "            SSHSCPBaseDir = \"\/tmp\""
#       puts $mapChannel "            SSHVersion = \"SSH-1.99-SSHSAPRO-4.3\""
#       puts $mapChannel "            SSHFile =  \"CiscoCat3750-SwRtr-Work.tel\""
#       puts $mapChannel "        />"
        puts $mapChannel "    />"
        incr curDevCount

        # Tell the GUI that we are done
        TPG_setstepsdone

        # Add the router's coordinates and ID to the tpg device list
        set rtrDevID [incr nextDevID]
        set rtrX [expr $rtrX + 10]

        if {$supportHosts} {
            set rtrCrntY [expr $hostCrntY + 100]
        } else {
            set rtrCrntY [expr $swCrntY + 100]
        }
        set swX $rtrX
        set swCrntY [expr $rtrCrntY + 100]
        set hostX $rtrX
        set hostCrntY [expr $swCrntY + 100]
        puts $tpgFile "  <Device x=\"$rtrX\" y=\"$rtrCrntY\" Type=\"0\" ID=\"$rtrDevID\" >"

        # Add the router's device properties
        puts -nonewline $tpgFile "   <DeviceProperties telnetModelingFile=\""
        if { $telRouterName != "None" } {
            puts -nonewline $tpgFile $telRouterName
        }
        puts -nonewline $tpgFile "\" MACAddress=\"${firstMacOctetHex}02020101${rtrOwnIndxHex}\" "
        puts -nonewline $tpgFile "snmpEnabled=\"YES\" tclModelingFile=\"\" "
        puts -nonewline $tpgFile "IPAddress=\"$devip\" vendorVarName=\"\" cmfName=\"[file nativename $routerCmfFile]\" "
        puts -nonewline $tpgFile "userDefinedCmfVar=\"YES\" maxInterfaces=\"$numswitches\" "
        puts -nonewline $tpgFile "vendorLogo=\"[file nativename [file join $imgPath router.bmp]]\" "
        puts -nonewline $tpgFile "vendorName=\"No Device Selected\" systemName=\"router_$rdid\" subnet=\""
        puts -nonewline $tpgFile "$seedipSubnet\" vendorCmfName=\"\" telnetPort=\"23\" mask=\""
        puts -nonewline $tpgFile "255.255.255.0\" telnetEnabled=\" "
        if { $telSeed1Name != "None" } {
            puts -nonewline $tpgFile "YES"
        } else {
            puts -nonewline $tpgFile "NO"
        }
        puts $tpgFile "\" varName=\"$varfile\" /> "

        # Add the router's interface list
        puts $tpgFile "   <InterfaceList>"
        puts -nonewline $tpgFile "    <Interface MACAddress=\"${firstMacOctetHex}02020101${rtrOwnIndxHex}\" "
        puts $tpgFile "InterfaceNumber=\"1\" IPAddress=\"$devip\" Mask=\"255.255.255.0\" />" 
        for {set j 1} {$j <= $numswitches} {incr j} {
            set indxDec [expr $j + 1]
            set indxHex [format "%02x" $indxDec]
            puts -nonewline $tpgFile "    <Interface MACAddress=\"${firstMacOctetHex}02${rtrIndxHex}${indxHex}0101\" "
            puts -nonewline $tpgFile "InterfaceNumber=\"$indxDec\" "
            puts $tpgFile "IPAddress=\"$startip.${rtrIndxDec}.$indxDec.2\" Mask=\"255.255.255.0\" />" 
        }
        puts $tpgFile "   </InterfaceList>"
        puts $tpgFile "  </Device>"

        # Add the link from the seed router to this one
        puts -nonewline $linkFile "  <Link interface1=\"$rtrIndxDec\" interface2=\"1\" devID1=\"1\" ifType=\"6\" "
        puts            $linkFile "devID2=\"$rtrDevID\" redundant=\"0\" />"

        # now add the 100 switches for this router
        for {set j 0} { $j < $numswitches } { incr j} {
            # Process any pending windowing events so that the GUI can be updated
            TPG_processwinevents

            set swOwnIndxDec [expr $j + 1]
            set swOwnIndxHex [format "%02x" $swOwnIndxDec]
            set swIndxDec [expr $j + 2]
            set swIndxHex [format "%02x" $swIndxDec]

            # check for optimization
            if {$curDevCount >= 100} {
                puts $mapChannel "</DeviceMap>"
                close $mapChannel
                incr curMapExt
                set mapChannel [open [file join $mapDir ${projName}_${curMapExt}.map] w+]
                if { $mapChannel == -1 } {
                    return 1;   # Could not open map file for writing
                }

                # Add the map to the map list
                lappend mapList [file join $mapDir ${projName}_${curMapExt}.map]

                puts $mapChannel "<DeviceMap"
                puts $mapChannel "    Release = \"11.0\""
                set timeStamp [clock format [clock seconds] -format "%D %T"]
                puts $mapChannel "    Description = \"SAPro Generated Map -- $timeStamp\""
                puts $mapChannel "    UserData = \"\""
                puts $mapChannel "    SetupFile = \"\""
                puts $mapChannel "    Interface = \"\""
                puts $mapChannel "    Separator = \"\""
                puts $mapChannel "    StartInterfaceNum = \"0\""

                # Only point to the TPG file if it contain less than 1000 devices
                if { $totalDevices <= 1000 } {
                    puts $mapChannel "    TPGFilePath = \"[file nativename [file join $dirName $projName tpg $projName.tpg]]\""
                }

                puts $mapChannel "    Username = \"SAProGenMap\">"
                set curDevCount 0
            }

            set swid       [expr $j + 2]
            set sdid       [expr $j + 1]
            set hexswid    [format "%02x" $swid]
            set decrwid    [format "%02d" $rwid]
            set decswid    [format "%02d" $swid]
            set devip      $startip.$rwid.$swid.1
            set devmac     ${firstMacOctetHex}03${hexrwid}01${hexswid}01
            set tokens     "$rwid,$hexrwid,$rwid.$swid,${hexrwid}${hexswid},${rwid}.1.1.${swid},${hexrwid}0101${hexswid},$swid,${decrwid}${decswid}"
            set varfile    "[file nativename [file join $varPath switch1.var]]"
        
            # Set the message in the progress bar window
            TPG_updatestatustext "$devip"

            # now add the device record for each line
            puts $mapChannel "    <Device"
            puts $mapChannel "        <General"
            puts $mapChannel "            Name = \"$devip\""
            puts $mapChannel "            MultiHome = \"1\""
            puts $mapChannel "            DHCP = \"0\""
            puts $mapChannel "            SubnetMask = \"255.255.255.0\""
            puts $mapChannel "            MacAddress = \"$devmac\""
            puts $mapChannel "            Interface = \"\""
            puts $mapChannel "            UserData = \"\""
            puts $mapChannel "            TopologyData = \"$tokens\""
            puts $mapChannel "            DisplayTag = \"switch_${rdid}_${sdid}\""
            puts $mapChannel "            DisplayLogo = \"[file nativename [file join $imgPath netdevice.bmp]]\""
            puts $mapChannel "            ModelingFile = \"\""
            puts $mapChannel "        />"
            puts $mapChannel "        <Snmp"
            puts $mapChannel "            ReadCommunity = \"public\""
            puts $mapChannel "            WriteCommunity = \"private\""
            puts $mapChannel "            MibFile = \"[file nativename $switchCmfFile]\""
            puts $mapChannel "            AgentFile = \"$varfile\""
            puts $mapChannel "            TrapMgr = \"\""
            puts $mapChannel "            ResponseDelay = \"0\""
            puts $mapChannel "            SnmpStr = \"V1V2V3\""
            puts $mapChannel "            MtuSize = \"1500\""
            puts $mapChannel "            SnmpPort = \"161\""
            puts $mapChannel "            SecurityLevel = \"NoAuthNoPriv\""
            puts $mapChannel "        />"
            if { $telSwitchName != "None" } {
                puts $mapChannel "        <Telnet"
                puts $mapChannel "            TelnetPort = \"23\""
                puts $mapChannel "            TelnetFile =alan.carwile@hds.com \"$telSwitchName\""
                puts $mapChannel "        />"
            }
#           puts $mapChannel "        <SSH"
#           puts $mapChannel "            SSHUserName = \"qatester\""
#           puts $mapChannel "            SSHPassword = \"qadevice\""
#           puts $mapChannel "            SSHSCPBaseDir = \"\/tmp\""
#           puts $mapChannel "            SSHVersion = \"SSH-1.99-SSHSAPRO-4.3\""
#           puts $mapChannel "            SSHFile =  \"CiscoCat2950-Switch-Work.tel\""
#           puts $mapChannel "        />"
            puts $mapChannel "    />"
            incr curDevCount

            # Tell the GUI that we are done
            TPG_setstepsdone

            # Add the switch's coordinates and ID to the tpg device list
            set swDevID [incr nextDevID]
            if {$supportHosts} {
                set swX $hostX
            } else {
                incr swX 80
            }
            puts $tpgFile "  <Device x=\"$swX\" y=\"$swCrntY\" Type=\"2\" ID=\"$swDevID\" >"

            # Add the switch's device properties
            puts -nonewline $tpgFile "   <DeviceProperties telnetModelingFile=\""
            if { $telRouterName != "None" } {
                puts -nonewline $tpgFile $telRouterName
            }
            puts -nonewline $tpgFile "\" MACAddress=\"${firstMacOctetHex}03${rtrIndxHex}${swOwnIndxHex}0101\" "
            puts -nonewline $tpgFile "snmpEnabled=\"YES\" tclModelingFile=\"\" "
            puts -nonewline $tpgFile "IPAddress=\"$devip\" vendorVarName=\"\" cmfName=\""
            puts -nonewline $tpgFile "[file nativename $switchCmfFile]\" "
            puts -nonewline $tpgFile "userDefinedCmfVar=\"YES\" maxInterfaces=\"$numswitches\" "
            puts -nonewline $tpgFile "vendorLogo=\"[file nativename [file join $imgPath netdevice.bmp]]\" "
            puts -nonewline $tpgFile "vendorName=\"No Device Selected\" systemName=\"switch_${rdid}_${sdid}\" subnet=\""
            puts -nonewline $tpgFile "$seedipSubnet\" vendorCmfName=\"\" telnetPort=\"23\" mask=\""
            puts -nonewline $tpgFile "255.255.255.0\" telnetEnabled=\" "
            if { $telSeed1Name != "None" } {
                puts -nonewline $tpgFile "YES"
            } else {
                puts -nonewline $tpgFile "NO"
            }
            puts $tpgFile "\" varName=\"$varfile\" /> "

            # Add the switch's interface list
            puts $tpgFile "   <InterfaceList>"
            puts -nonewline $tpgFile "    <Interface MACAddress=\"${firstMacOctetHex}03${rtrIndxHex}${swOwnIndxHex}0101\" "
            puts $tpgFile "InterfaceNumber=\"1\" IPAddress=\"$devip\" Mask=\"255.255.255.0\" />" 
            for {set k 1} {$k <= $numhosts} {incr k} {
                set indxDec [expr $k + 1]
                set indxHex [format "%02x" $indxDec]
                puts -nonewline $tpgFile "    <Interface MACAddress=\"${firstMacOctetHex}03${rtrIndxHex}${indxHex}0101\" "
                puts -nonewline $tpgFile "InterfaceNumber=\"$indxDec\" "
                puts $tpgFile "IPAddress=\"\" Mask=\"\" />" 
            }
            puts $tpgFile "   </InterfaceList>"
            puts $tpgFile "  </Device>"

            # Add the link from the parent router to this switch
            puts -nonewline $linkFile "  <Link interface1=\"$swid\" interface2=\"1\" devID1=\"${rtrDevID}\" ifType=\"6\" "
            puts            $linkFile "devID2=\"$swDevID\" redundant=\"0\" />"

            if {$supportHosts} {
                # Initialize the host X coordinate -- first one lines up to parent switch
                set hostX $swX

                # now add the hosts for this switch
                # .1 and .2 are used by the switch and the upstream router
                # start from .3
                for {set k 0} { $k < $numhosts } { incr k} {
                    # Process any pending windowing events so that the GUI can be updated
                    TPG_processwinevents

                    # check for optimization
                    if {$curDevCount >= 100} {
                        puts $mapChannel "</DeviceMap>"
                        close $mapChannel
                        incr curMapExt
                        set mapChannel [open [file join $mapDir ${projName}_${curMapExt}.map] w+]
                        if { $mapChannel == -1 } {
                            return 1;   # Could not open map file for writing
                        }

                        # Add the map to the map list
                        lappend mapList [file join $mapDir ${projName}_${curMapExt}.map]

                        puts $mapChannel "<DeviceMap"
                        puts $mapChannel "    Release = \"11.0\""
                        set timeStamp [clock format [clock seconds] -format "%D %T"]
                        puts $mapChannel "    Description = \"SAPro Generated Map -- $timeStamp\""
                        puts $mapChannel "    UserData = \"\""
                        puts $mapChannel "    SetupFile = \"\""
                        puts $mapChannel "    Interface = \"\""
                        puts $mapChannel "    Separator = \"\""
                        puts $mapChannel "    StartInterfaceNum = \"0\""

                        # Only point to the TPG file if it contain less than 1000 devices
                        if { $totalDevices <= 1000 } {
                            puts $mapChannel "    TPGFilePath = \"[file nativename [file join $dirName $projName tpg $projName.tpg]]\""
                        }

                        puts $mapChannel "    Username = \"SAProGenMap\">"
                        set curDevCount 0
                    }

                    set hwid       [expr $k + 3]
                    set hdid       [expr $k + 1]
                    set hexhwid    [format "%02x" $hwid]
                    set hexhdid    [format "%02x" $hdid]
                    set devip      $startip.$rwid.$swid.$hwid
                    set devmac     ${firstMacOctetHex}04${hexrwid}${hexswid}${hexhdid}01
                    set tokens     "$crouter"
                    set varfile    "[file nativename [file join $varPath host1.var]]"
        
                    # Set the message in the progress bar window
                    TPG_updatestatustext "$devip"

                    # now add the device record for each line:w
                    puts $mapChannel "    <Device"
                    puts $mapChannel "        <General"
                    puts $mapChannel "            Name = \"$devip\""
                    puts $mapChannel "            MultiHome = \"1\""
                    puts $mapChannel "            DHCP = \"0\""
                    puts $mapChannel "            SubnetMask = \"255.255.255.0\""
                    puts $mapChannel "            MacAddress = \"$devmac\""
                    puts $mapChannel "            Interface = \"\""
                    puts $mapChannel "            UserData = \"\""
                    puts $mapChannel "            TopologyData = \"$tokens\""
                    puts $mapChannel "            DisplayTag = \"host_${rdid}_${sdid}_${hdid}\""
                    puts $mapChannel "            DisplayLogo = \"[file nativename [file join $imgPath host.bmp]]\""
                    puts $mapChannel "            ModelingFile = \"\""
                    puts $mapChannel "        />"
                    puts $mapChannel "        <Snmp"
                    puts $mapChannel "            ReadCommunity = \"public\""
                    puts $mapChannel "            WriteCommunity = \"private\""
                    puts $mapChannel "            MibFile = \"[file nativename $hostCmfFile]\""
                    puts $mapChannel "            AgentFile = \"$varfile\""
                    puts $mapChannel "            TrapMgr = \"\""
                    puts $mapChannel "            ResponseDelay = \"0\""
                    puts $mapChannel "            SnmpStr = \"V1V2V3\""
                    puts $mapChannel "            MtuSize = \"1500\""
                    puts $mapChannel "            SnmpPort = \"161\""
                    puts $mapChannel "            SecurityLevel = \"NoAuthNoPriv\""
                    puts $mapChannel "        />"
                    if { $telHostName != "None" } {
                        puts $mapChannel "        <Telnet"
                        puts $mapChannel "            TelnetPort = \"23\""
                        puts $mapChannel "            TelnetFile = \"$telHostName\""
                        puts $mapChannel "        />"
                    }
                    puts $mapChannel "    />"
                    incr curDevCount

                    # Tell the GUI that we are done
                    TPG_setstepsdone

                    # Add the host's coordinates and ID to the tpg device list
                    set hostDevID [incr nextDevID]
                    puts $tpgFile "  <Device x=\"$hostX\" y=\"$hostCrntY\" Type=\"3\" ID=\"$hostDevID\" >"
                    incr hostX 80

                    # Add the host's device properties
                    puts -nonewline $tpgFile "   <DeviceProperties telnetModelingFile=\""
                    if { $telRouterName != "None" } {
                        puts -nonewline $tpgFile $telRouterName
                    }
                    puts -nonewline $tpgFile "\" MACAddress=\"${devmac}\" "
                    puts -nonewline $tpgFile "snmpEnabled=\"YES\" tclModelingFile=\"\" "
                    puts -nonewline $tpgFile "IPAddress=\"$devip\" vendorVarName=\"\" cmfName=\""
                    puts -nonewline $tpgFile "[file nativename $hostCmfFile]\" "
                    puts -nonewline $tpgFile "userDefinedCmfVar=\"YES\" maxInterfaces=\"2\" "
                    puts -nonewline $tpgFile "vendorLogo=\"[file nativename [file join $imgPath host.bmp]]\" "
                    puts -nonewline $tpgFile "vendorName=\"No Device Selected\" systemName=\"host_${rdid}_${sdid}_${hdid}\" subnet=\""
                    puts -nonewline $tpgFile "$seedipSubnet\" vendorCmfName=\"\" telnetPort=\"23\" mask=\""
                    puts -nonewline $tpgFile "255.255.255.0\" telnetEnabled=\" "
                    if { $telSeed1Name != "None" } {
                        puts -nonewline $tpgFile "YES"
                    } else {
                        puts -nonewline $tpgFile "NO"
                    }
                    puts $tpgFile "\" varName=\"$varfile\" /> "

                    # Add the host's interface list
                    puts $tpgFile "   <InterfaceList>"
                    puts -nonewline $tpgFile "    <Interface MACAddress=\"000000000000\" "
                    puts $tpgFile "InterfaceNumber=\"1\" IPAddress=\"\" Mask=\"\" />" 
                    puts -nonewline $tpgFile "    <Interface MACAddress=\"${devmac}\" "
                    puts $tpgFile "InterfaceNumber=\"2\" IPAddress=\"$devip\" Mask=\"255.255.255.0\" />" 
                    puts $tpgFile "   </InterfaceList>"
                    puts $tpgFile "  </Device>"

                    # Add the link from the parent switch to this host
                    puts -nonewline $linkFile "  <Link interface1=\"[expr $hdid + 1]\" interface2=\"2\" devID1=\"${swDevID}\" ifType=\"6\" "
                    puts            $linkFile "devID2=\"$hostDevID\" redundant=\"0\" />"
                }
            }
        }
    }

    # Terminate the map definition
    puts $mapChannel "</DeviceMap>"

    # Tell the GUI that we are done. Set the message in the progress bar window
    TPG_setstepsdone
    TPG_updatestatustext "Map(s) created...."

    # Process any pending windowing events so that the GUI can be updated
    TPG_processwinevents

    close $mapChannel

    # Terminate the map list
    puts $tpgFile " </DeviceList>"

    # Rewind the link list and copy it to the tpg file
    seek $linkFile 0
    while {[gets $linkFile line] >= 0} {
        puts $tpgFile $line
    }

    # Terminate the link list, terminate document, and close the file
    puts $tpgFile " </LinkList>"
    puts $tpgFile "</Doc>"
    
    close $tpgFile
    close $linkFile

    file delete [file join $dirName $projName tpg zzz${projName}.link]

    return $mapList
}

proc updateSapDefines { updateList sourceFile targetFile } {
    # Build the table of variables and corresponding replacement values
    set count 0
    foreach updatePair $updateList {
        set varList($count) [lindex $updatePair 0]
        set valList($varList($count)) [lindex $updatePair 1]
        incr count
    }

    # Open the source and target files
    set inFile [open $sourceFile r]
    set outFile [open $targetFile w]

    # For each line in the source file
    while {[gets $inFile line] >= 0} {
        # Process any pending windowing events so that the GUI can be updated
        TPG_processwinevents

        # Check to see if the current line is a sapdefine
        if { [string first "%sapdefine" $line] >= 0 } {

            # Search the replace table to see if we have a match
            for {set i 0} {$i < $count} {incr i} {
                # Process any pending windowing events so that the GUI can be updated
                TPG_processwinevents

                # Parse the line into tokens
                set tokens [split $line]

                # If the variable names match, replace the value in the line
                if { $varList($i) == [lindex $tokens 1] } {
                    set line "%sapdefine $varList($i) $valList($varList($i))"
                } 
            }
        }

        # Write the line out to the target file
        puts $outFile $line
    }

    close $inFile
    close $outFile
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
# Procedure:    mergeFiles
# Input:        file1       Base file
#               file2       Rile appended to base file
# Output:       resFile     Resulting file
# Description:  This procedure recreates resFile by appending file2 to file1.
#
###############################################################################
proc mergeFiles { file1 file2 resFile } {
    if { [file copy -force -- $file1 $resFile] == 0 } {
        error "Failed to copy $file1 to $resFile"
    }

    set resChannel [open $resFile a+]
    set mergeChannel [open $file2 r]

    while { [gets $mergeChannel sourceLine] >= 0 } {
        puts $resChannel $sourceLine
    }

    close $resChannel
    close $mergeChannel
}

