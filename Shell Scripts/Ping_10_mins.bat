Rem this batch file pings a server every 12.5 mins
:Start
Ping pac2-www2-streetscape.fmr.com 
Ping -w 12500 1.1.1.1 
Goto Start
