@echo ---
@echo Version 2018-03-05-1933
@echo ---
set /p ip=<"ip.txt"
set /p ipall=<"ipall.txt"
@echo ---
@echo %ip%
@echo ---
@echo %ipall%
@echo ---
sendEmail.dll -f email@hotmail.com -t email@hotmail.com -s smtp.live.com -xu email@hotmail.com -xp XXXYOURPASSWORDHEREXXX -u "Hello from External Ip Deamon %ip%" -m "Daily ip check. %ip% %ipall%. All info of IP's in attachements."
@echo ---
@exit