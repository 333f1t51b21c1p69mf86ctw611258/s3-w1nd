# set device1's interface down
%devname 128.100.100.102
    SA_setvar {{ifAdminStatus.1 Integer 2}}
# set device2's interface up
%devname 128.100.100.103
    SA_setvar {{ifAdminStatus.1 Integer 1}}
