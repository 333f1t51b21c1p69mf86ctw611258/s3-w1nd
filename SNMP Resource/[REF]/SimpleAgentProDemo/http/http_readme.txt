To support HTTP in conjunction with Apache Web Server

1) Please install Apache Web server on your machine.
 
   You can get Apache binaries from http://www.apache.org
   For ssl support, if located within the US, you can get
   pre made binaries from http://www.devside.net

   Follow the instructions to get apache up and running 
   on your machine.

2) Edit the config.inp file and update the
       APACHEWEBSERVER = c:/www/apache2/bin/apache
   example entry to point to the location where 
   you have installed Apache

3) Edit the httpd.conf file (typically in the "conf" directory
   in the apache installation) and add a line at the end 
   of the file :

   include "c:/program files/SimpleAgentPro/http/httpd.conf"

   Please note that you need to change the above path to
   SimpleAgentPro to reflect the location where you have
   installed SimpleAgentPro on your machine

4) If using https, edit the sslinc.conf file in the 
   SimpleAgentPro/http directory and make the SSL files
   point to the SSL files currently used in your Apache
   installation. 
   Thereafter, when defining a device with https support,
   please specify this as the "ssl include" file for the
   device.