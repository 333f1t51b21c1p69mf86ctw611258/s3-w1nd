%init_action
    set myip [SA_getmyip]
    SA_settcldebugflag 1
    SA_settcldebugfile tcl_${myip}.dbg
    SA_setsnmpdebugflag 2
    SA_setsnmpdebugfile snmp_${myip}.dbg
    set cloneUser ""
    set newAuthKey ""
    set newPrivKey ""
    # Set up the SNMP Engine ID MIB object to match the device's ID
    set myiplist [split $myip "."]
    set ip1 [format "%02x" [lindex $myiplist 0]]
    set ip2 [format "%02x" [lindex $myiplist 1]]
    set ip3 [format "%02x" [lindex $myiplist 2]]
    set ip4 [format "%02x" [lindex $myiplist 3]]
    SA_setvaltype [list [list snmpEngineID.0 OctetString "fixed(0x8000031201${ip1}${ip2}${ip3}${ip4})"]]

proc extractUserName { oid } {
    set oidList [split $oid "."]

#   Get the User Name from the index
    set engIDLen [lindex $oidList 12]
    set usrIDLen [lindex $oidList [expr $engIDLen + 13]]
    set usrIDIdx [expr $engIDLen + 14]
    set usrName ""
    for { set i $usrIDIdx } { $i < [llength $oidList] } { incr i } {
        append usrName [format "%c" [lindex $oidList $i]]
   }

    return $usrName
}

proc updateV3UserProto {cloneUser instance} {
    set v3UserInfo [SA_getv3userinfo $cloneUser]
    set secLevel [lindex $v3UserInfo 1]
    set authType [lindex $v3UserInfo 2]
    if { $secLevel == 1 } {      ;# secLevel = noAuth/noPriv
        set authProto "1.3.6.1.6.3.10.1.1.1"
        set privProto "1.3.6.1.6.3.10.1.2.1"
    } elseif { $secLevel == 2 } {;# secLevel = Auth/noPriv
        if { $authType == 1 } {         ;# authType = MD5
            set authProto "1.3.6.1.6.3.10.1.1.2"
            set privProto "1.3.6.1.6.3.10.1.2.1"
        } else {                        ;# authType = SHA
            set authProto "1.3.6.1.6.3.10.1.1.3"
            set privProto "1.3.6.1.6.3.10.1.2.1"
        }
    } elseif { $secLevel == 3 } {;# secLevel = Auth/Priv
        if { $authType == 1 } {         ;# authType = MD5
            set authProto "1.3.6.1.6.3.10.1.1.2"
            set privProto "1.3.6.1.6.3.10.1.2.2"
        } else {                        ;# authType = SHA
            set authProto "1.3.6.1.6.3.10.1.1.3"
            set privProto "1.3.6.1.6.3.10.1.2.2"
        }
    }

    SA_setvar [list [list 1.3.6.1.6.3.15.1.2.2.1.5.$instance ObjectID $authProto] \
                    [list 1.3.6.1.6.3.15.1.2.2.1.8.$instance ObjectID $privProto]]
}

%after_set_action usmUserAuthKeyChange
    set varbind [SA_getreqvb]
    set curvb  [lindex $varbind 0]
    set curOid [lindex $curvb 0]
    set newAuthKey [lindex $curvb 2]
    set newUser [extractUserName $curOid]
    SA_changev3authkey $newUser $newAuthKey

%after_set_action usmUserPrivKeyChange
    set varbind [SA_getreqvb]
    set curvb  [lindex $varbind 0]
    set curOid [lindex $curvb 0]
    set newPrivKey [lindex $curvb 2]
    set newUser [extractUserName $curOid]
    SA_changev3privkey $newUser $newPrivKey

%after_set_action usmUserCloneFrom
    set varbind [SA_getreqvb]
    set curvb  [lindex $varbind 0]
    set cloneUser [extractUserName [lindex $curvb 2]]

%after_all_set_action usmUserStatus
    set crntVB [SA_getreqvb]
    SA_puts "\nusmUserStatus = [lindex [lindex $crntVB 0] 2]\n"
    set usmUserStatus  [lindex [lindex $crntVB 0] 2]
    if { $usmUserStatus == 5 ||
         $usmUserStatus == 4 } { ;# Status is create and wait
        set crntOID [lindex [lindex $crntVB 0] 0]
        set instance [string range $crntOID 25 end]

        set newUser [extractUserName $crntOID]
        SA_puts "cloneUser = \"$cloneUser\"\n"
        SA_setafterresponseid 1
    }
        

%after_snmp_response
    set myid [SA_getafterresponseid]
    if {$myid == 1} {

        if { $cloneUser != ""  } {
            SA_clonev3user $cloneUser $newUser

            updateV3UserProto $cloneUser $instance
            set cloneUser ""
        }
    }
