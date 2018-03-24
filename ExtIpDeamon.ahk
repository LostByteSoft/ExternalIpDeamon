;;--- Head --- Informations --- AHK ---

;;	Compatibility: Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	Use as a developpement tool for AHK
;;	This entire thing (work) is a developpement tool for AHK scripting.
;;	Use an external EXE or DLL file for icon is shit load of job and the final quality is less.

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent
	#NoEnv
	#Warn
	;; #NoTrayIcon
	SetTitleMatchMode, Slow
	SetTitleMatchMode, 2

	SetEnv, title, External Ip Deamon
	SetEnv, mode, Get external IP. Deamon for servers.
	SetEnv, version, Version 2018-03-24-1012
	SetEnv, Author, LostByteSoft
	SetEnv, icofolder, C:\Program Files\Common Files\
	SetEnv, logoicon, ico_loupe.ico

	SetEnv, debug, 0
	SetEnv, sendall24h, 0

	;; Specific Icons (or files)
	FileInstall, ico_loupe.ico, %icofolder%\ico_loupe.ico, 0
	FileInstall, ico_loupe_w.ico, %icofolder%\ico_loupe_w.ico, 0
	FileInstall, img_warning.jpg, %icofolder%\img_warning.jpg, 0
	FileInstall, ico_clipboard.ico, %icofolder%\ico_clipboard.ico, 0

	;; Common ico
	FileInstall, ico_about.ico, %icofolder%\ico_about.ico, 0
	FileInstall, ico_lock.ico, %icofolder%\ico_lock.ico, 0
	FileInstall, ico_options.ico, %icofolder%\ico_options.ico, 0
	FileInstall, ico_reboot.ico, %icofolder%\ico_reboot.ico, 0
	FileInstall, ico_shut.ico, %icofolder%\ico_shut.ico, 0
	FileInstall, ico_debug.ico, %icofolder%\ico_debug.ico, 0
	FileInstall, ico_HotKeys.ico, %icofolder%\ico_HotKeys.ico, 0
	FileInstall, ico_pause.ico, %icofolder%\ico_pause.ico, 0
	FileInstall, ico_loupe.ico, %icofolder%\ico_loupe.ico, 0
	FileInstall, ico_folder.ico, %icofolder%\ico_folder.ico, 0

	IfNotExist, sendEmail.dll, goto, error

;;--- Set email and password here ---

	;; Email and password is not crypted so be carefull.

	;; Hard to find with inputbox email and password. (Is somewhere in computer ram)

	InputBox, email , %Title%, Your email here :, , , , , , , , @hotmail.com
	InputBox, pass , %Title%, Your password email here :

	;; Easy mail and pass but not encrypted.

	;; SetEnv, email, jeanvaljean@hotmail.com
	;; SetEnv, pass, ilikepotatoes

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %icofolder%\%logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program.
	Menu, Tray, Icon, Secret MsgBox, %icofolder%\ico_lock.ico
	Menu, tray, add, About && ReadMe, author				; infos about author
	Menu, Tray, Icon, About && ReadMe, %icofolder%\ico_about.ico
	Menu, tray, add, Author %author%, about					; author msg box
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about					; version of the software
	menu, tray, disable, %version%
	Menu, tray, add, Open project web page, webpage				; open web page project
	Menu, Tray, Icon, Open project web page, %icofolder%\ico_HotKeys.ico
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, %icofolder%\ico_options.ico
	menu, tray, add, Show Gui (Same as click), start			; Default gui open
	Menu, Tray, Icon, Show Gui (Same as click), %icofolder%\ico_loupe.ico
	Menu, Tray, Default, Show Gui (Same as click)
	Menu, Tray, Click, 1
	Menu, tray, add, Set Debug (Toggle), debug				; debug msg
	Menu, Tray, Icon, Set Debug (Toggle), %icofolder%\ico_debug.ico
	Menu, tray, add, Open A_WorkingDir, A_WorkingDir			; open where the exe is
	Menu, Tray, Icon, Open A_WorkingDir, %icofolder%\ico_folder.ico
	Menu, tray, add,
	Menu, tray, add, Exit %title%, ExitApp					; Close exit program
	Menu, Tray, Icon, Exit %title%, %icofolder%\ico_shut.ico
	Menu, tray, add, Refresh (Ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (Ini mod), %icofolder%\ico_reboot.ico
	Menu, tray, add, Pause (Toggle), pause					; pause the script
	Menu, Tray, Icon, Pause (Toggle), %icofolder%\ico_pause.ico
	Menu, tray, add,
	Menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, %icofolder%\ico_options.ico
	menu, tray, add,
	menu, tray, add, Send email all 24 hours (toggle), select24h
	menu, tray, add,
	menu, tray, add, Show "ip.txt", openip
	menu, tray, add, Show "ipall.txt", openipall
	menu, tray, add, Send test email now !, emailtest
	menu, tray, add, Copy all info in clipboard, allinfo
	Menu, Tray, Icon, Copy all info in clipboard, %icofolder%\ico_clipboard.ico
	menu, tray, add, Copy IP in clipboard, ipclip
	Menu, Tray, Icon, Copy IP in clipboard, %icofolder%\ico_clipboard.ico
	menu, tray, add, Check ext ip now, checker
	menu, tray, add,
	Menu, Tray, Tip, %mode%
	Menu, Tray, Icon, %icofolder%\ico_loupe_w.ico

;;--- Software start here ---

start:
	IfEqual, debug , 1, (start) It will send an email ONLY if the IP has changed.
	;; 1000 = 1 sec
	;; 60000 = 1 min
	;; 3 600 000 = 1 hour
	;; 43200000 = 12 hours
	;; 86400000 = 24 hours
	;; 2147483647 = 24 days ; maximum
	;; https://autohotkey.com/board/topic/6601-get-current-external-ip-address/page-2
	;; <?php
	;; /* Check IP */
	;; $ip = getenv("REMOTE_ADDR");
	;; echo $ip;
	;; ?>
	IfEqual, debug, 1, goto, showgui
	UrlDownloadToFile, http://7fw.de/ipraw.php, ip.txt
	showgui:
	FileReadLine, ExternalIP, ip.txt, 1
	SetEnv, ExternalIPold, %ExternalIP%
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	Msgbox, 64, %title% (Time out 20 sec), (Start:) External IP Address checker`n`nComputerName=%A_ComputerName%`n`nLocalIp=%A_IPAddress1%`n`nMyExternalIP=%ExternalIP%`n`nStart time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n`t(External IP in clipboard), 20
	clipboard = MyExternalIP = %ExternalIP%
	SetEnv, data, ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	FileAppend, %data%`n`n, %A_ScriptDir%\ipall.txt
	goto, sleep24h

checker:
	IfEqual, debug , 1, (checker) Compare 2 ip, old and new.
	UrlDownloadToFile, http://7fw.de/ipraw.php, ip.txt
	FileReadLine, ExternalIP, ip.txt, 1
	SetEnv, ExternalIPnew, %ExternalIP%
	IfEqual, debug, 1, msgbox, (Checker:) (No time out)`n`nExternalIPold=%ExternalIPold% = or /= ExternalIPnew=%ExternalIPnew%
	TrayTip, %title%,IP checked ExternalIP=%ExternalIPnew%, 1, 2
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	clipboard = ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	SetEnv, data, ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	FileAppend, %data%`n`n, %A_ScriptDir%\ipall.txt
	IfEqual, ExternalIPold, %ExternalIPnew%, goto, sleep24h
	Goto, Email

emailtest:
	IfEqual, debug, 1, msgbox, (Emailtest:) Email test
	Gui, 3:Add, Picture, x0 y0 w1000 h542 , %icofolder%\img_warning.jpg
	Gui, 3:Font, S20 Cwhite Bold, Verdana

	Gui, 3:Add, Text, BackgroundTrans x250 y150 w540 h40 , Test sending email !


	Gui, 3:Show, w1000 h542, %title% %mode%
	goto, email2

email:
	Gui, 3:Add, Picture, x0 y0 w1000 h542 , %icofolder%\img_warning.jpg
	Gui, 3:Font, S20 Cwhite Bold, Verdana

	Gui, 3:Add, Text, BackgroundTrans x250 y150 w540 h40 , Your external IP has changed !


	Gui, 3:Show, w1000 h542, %title% %mode%
	email2:
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	clipboard = ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	SetEnv, data, ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	FileAppend, %data%`n`n, %A_ScriptDir%\ipall.txt
	IfNotExist, sendEmail.dll, goto, error
	FileRead, ip, %A_ScriptDir%\ip.txt
	FileRead, ipall, %A_ScriptDir%\ipall.txt
	IfEqual, debug, 1, msgbox, (email:) External IP has changed. Email was NOT sent in debug=1 mode !`n`nComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%`n`nYhis is what is send via email:`n`nip=%ip%`n`nipall=%ipall%
	IfEqual, debug, 1, goto, skip1
	;;run, sendEmail.dll -f %email% -t %email% -s smtp.live.com -xu %email% -xp %pass% -u "Hello from External Ip Deamon %ip%" -m "Daily ip check %ip%`n`n%ipall%.`nAll info of IP's in attachements." -a "%A_ScriptDir%\ipall.txt",,min
	run, sendEmail.dll -f %email% -t %email% -s smtp.live.com -xu %email% -xp %pass% -u "Hello from External Ip Deamon %ip%" -m "WARNING your external ip has changed %ip%`n`n%ipall%.
	skip1:
	UrlDownloadToFile, http://7fw.de/ipraw.php, ip.txt
	FileReadLine, ExternalIP, ip.txt, 1
	SetEnv, ExternalIPold, %ExternalIP%
	goto, sleep24h

select24h:
	IfEqual, sendall24h, 0, goto, sendall24h1
	IfEqual, sendall24h, 1, goto, sendall24h0

	sendall24h0:
	SetEnv, sendall24h, 0
	Goto, checker

	sendall24h1:
	SetEnv, sendall24h, 1
	Goto, send24h

send24h:
	IfEqual, debug, 1, msgbox, (send24h:) Send email all 24 hours.
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)

	Msgbox, 64, %title% (Time out 30 sec), (Send24h:) External IP Address checker debug=%debug% Send an email to all 24 hours. This message will appear all 24 hours. It have a timeout of 30 seconds.`n`nComputerName=%A_ComputerName%`n`nLocalIp=%A_IPAddress1%`n`nMyExternalIP=%ExternalIP%`n`nStart time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n`t(External IP in clipboard), 30

	clipboard = ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	SetEnv, data, ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	FileAppend, %data%`n`n, %A_ScriptDir%\ipall.txt
	IfNotExist, sendEmail.dll, goto, error
	FileRead, ip, %A_ScriptDir%\ip.txt
	FileRead, ipall, %A_ScriptDir%\ipall.txt
	;;run, sendEmail.dll -f %email% -t %email% -s smtp.live.com -xu %email% -xp %pass% -u "Hello from External Ip Deamon %ip%" -m "Daily ip check %ip%`n`n%ipall%.`n`nAll info of IP's in attachements." -a "%A_ScriptDir%\ipall.txt",,min
	run, sendEmail.dll -f %email% -t %email% -s smtp.live.com -xu %email% -xp %pass% -u "Hello from External Ip Deamon 24 h send." -m "24H ip send %ip%`n`n%ipall%.
	Sleep, 86400000
	goto, send24h

sleep24h:
	IfEqual, debug, 1, msgbox, (sleep24h:) Sleepng for 24 hours before check again.
	Sleep, 86400000
	goto, checker

allinfo:
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	clipboard = ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	SetEnv, data, ComputerName=%A_ComputerName% LocalIp=%A_IPAddress1% MyExternalIP=%ExternalIP% Start time: %t_StartTime% Time now: %t_NowTime% Elapsed time: %t_UpTime%
	FileAppend, %data%`n`n, %A_ScriptDir%\ipall.txt
	Return

error:
	MsgBox, 17, %title%, (Error:) File sendEmail.dll was not found in same directory of ExtIpDeamon.exe (Will exit)
	Goto, exitapp

;;--- Quit ---

;; Escape::
	ExitApp

GuiClose:
	Gui, destroy
	goto, start

ExitApp:
	ExitApp

doReload:
	Reload
	sleep, 100
	goto, ExitApp

;;--- Debug ---

debug:
	IfEqual, debug, 0, goto, debug1
	IfEqual, debug, 1, goto, debug0

	debug0:
	SetEnv, debug, 0
	TrayTip, %title%, Deactivated ! debug=%debug%, 1, 2
	Goto, sleep2

	debug1:
	SetEnv, debug, 1
	TrayTip, %title%, Activated ! debug=%debug%, 1, 2
	Goto, sleep2

;;--- Pause ---

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
	SetEnv, pause, 1
	goto, sleep

	unpaused:	
	Menu, Tray, Icon, %logoicon%
	SetEnv, pause, 0
	Goto, start

	sleep:
	Menu, Tray, Icon, %icofolder%\ico_pause.ico
	sleep2:
	sleep, 500000
	goto, sleep2

;;--- Tray Bar (must be at end of file) ---

secret:
	FileReadLine, ExternalIP, ip.txt, 1
	SetEnv, ExternalIPnew, %ExternalIP%
	MsgBox, 64, %title%, (Secret:) All variables is shown here.`n`ntitle=%title% mode=%mode% version=%version% author=%author% LogoIcon=%logoicon% Debug=%debug% SendAll24h=%Sendall24h%`n`nA_WorkingDir=%A_WorkingDir%`nIcoFolder=%icofolder%`n`nExternalIPold=%ExternalIPold% ExternalIPnew=%ExternalIPnew%`n`nClipboard (if text)=%clipboard%
	Return

about:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Sleep, 500
	Return

version:
	TrayTip, %title%, %version%, 2, 2
	Sleep, 500
	Return

Author:
	MsgBox, 64, %title%, (Author:) %title% %mode% %version% %author% This software is usefull to get informations and external ip.`n`n`tGo to https://github.com/LostByteSoft
	Return

GuiLogo:
	Gui, 4:Add, Picture, x25 y25 w400 h400, %icofolder%\ico_loupe_w.ico
	Gui, 4:Show, w450 h450, %title% Logo
	Gui, 4:Color, 000000
	Gui, 4:-MinimizeBox
	Sleep, 500
	Return

	3GuiClose:
	Gui 3:Cancel
	return

	4GuiClose:
	Gui 4:Cancel
	return

A_WorkingDir:
	IfEqual, debug, 1, msgbox, (A_WorkingDir:) run explorer.exe "%A_WorkingDir%"
	run, explorer.exe "%A_WorkingDir%"
	Return

openip:
	run, notepad.exe "%A_ScriptDir%\ip.txt"
	return

openipall:
	run, notepad.exe "%A_ScriptDir%\ipall.txt"
	return

ipclip:
	clipboard=%ExternalIP%
	Return

webpage:
	run, https://github.com/LostByteSoft/ExternalIpDeamon
	Return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;      LostByteSoft no copyright or copyleft we are in the center.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---