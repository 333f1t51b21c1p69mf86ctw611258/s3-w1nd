#!../bin/saptclsh
#######################################################
# Copyright 2001 SIMPLESOFT Inc.  All rights reserved
#######################################################

#######################################################
# configuration settings
#######################################################
#
# what is the file name that you want the learned output
# to go to
#
set outputfile          "learn_sim.tel"
#
# does the box prompt for a user  (1 yes, 0 no)
#
set userpromptflag      0
#
# if it does, what is the last prompt character
set userpromptchar      ":"
#
# if it does, what should the user name be
set username            "admin"
#
# does the box prompt for a password  (1 yes, 0 no)
#
set paswdpromptflag     1
#
# if it does, what is the last prompt character
set paswdpromptchar     ":"
#
# if it does, what is the password
set password            "pqr"
#
# what are the last characters of the command prompt
#
set cmdprompt1char      "#"
set cmdprompt2char      ">"
#
# how long should we wait for a response (in secs)
set timeout             2
#
# does the telnet session have an additional login
# to a special admin mode  ( 1 yes, 0 no)
set addloginflag        1
#
# what is the command to enter it
set addlogincommand     "enable"
#
# what are the last characters of the password prompt
set addpaswdpromptchar  ":"
#
# what is the password of the additional login prompt
set addloginpasswd      "bigfish"
#
# should we learn only those lines from the output that
# have a newline at the end ? (1 yes, 0 no)
#
set getonlynewline      1
#
# should blank lines be skipped (1 yes, 0 no)
#
set skipblankline       1

#######################################################
# command list to be learnt
#######################################################
set commandlist   { 
                      "show version" \
                      "enable" \
                      "show interfaces fastethernet 1/0/7" \
                  }


#######################################################
# actual call to the procedure with the device ip specified
#######################################################
sapro_telnet_learner 192.168.100.250
    
