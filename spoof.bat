@echo off
cls
echo [+] Changing registry values...
reg add HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName /v ComputerName /t REG_SZ /d %random% /f >nul 2>&1
reg add HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName /v ComputerName /t REG_SZ /d %random% /f >nul 2>&1
reg add HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation /v ComputerHardwareId /t REG_SZ /d {%random%%random%-%random%%random%-%random%%random%} /f >nul 2>&1
reg add HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation /v ComputerHardwareIds /t REG_SZ /d %random%%random%-%random%%random%-%random%%random% /f >nul 2>&1

rem Repeat similar registry changes for all other entries...

rem Spoofing IP
echo [+] Spoofing IP...
ipconfig /flushdns
netsh int ip reset
netsh int reset all
netsh int ipv4 reset
netsh int ipv6 reset
netsh winsock reset
netsh advfirewall reset
netsh winsock reset catalog

rem Delete system shadow copies and reset disks
echo [+] Resetting System...
powershell vssadmin delete shadows /all >nul 2>&1
powershell Reset-PhysicalDisk * >nul 2>&1
fsutil usn deletejournal /n C: >nul 2>&1
fsutil usn deletejournal /n D: >nul 2>&1
fsutil usn deletejournal /n E: >nul 2>&1
fsutil usn deletejournal /n F: >nul 2>&1

rem Restart Windows Management
echo [+] Refreshing WinMgmt...
net stop winmgmt /y
net start winmgmt

rem Change MAC Address
echo [+] Changing MAC Address...
C:\Windows\macer.BAT

rem Delete Unnecessary Files
echo [+] Deleting Unnecessary Files...
del /s /f /q C:\Windows\System32\restore\MachineGuid.txt
del /s /f /q C:\System Volume Information\IndexerVolumeGuid
del /s /f /q C:\System Volume Information\tracking.log
del /s /f /q C:\Windows\INF\setupapi.dev.log
del /s /f /q C:\Windows\INF\setupapi.setup.log
rmdir /s /q C:\Windows\temp
rmdir /s /q C:\Users\%username%\AppData\Local\Temp
rmdir /s /q C:\Windows\Prefetch

rem Clearing environment
echo [+] Clearing environment...
del /s /f /q C:\Windows\Solution.exe
del /s /f /q C:\Windows\Solution64.sys
del /s /f /q C:\Windows\Disk1.exe
del /s /f /q C:\Windows\Disk2.exe
del /s /f /q C:\Windows\macer.bat

echo [+] Completed!
exit
