robocopy.exe "\\corp-file-vs12\wintel\postbuild\Package" "C:\temp\package" /COPYALL /SEC /E /ZB /TEE /R:1 /W:1 /DCOPY:T
cd c:\temp\package
msiexec /i c:\temp\package\AvamarClient-windows-x86_64-7.2.100-401.msi /q
msiexec /i C:\temp\package\Fireeye\AgentSetup_11.11.8_universal.msi /q
C:\temp\package\scepinstaller_4.9.exe /s /q
cd C:\temp\package\SCCM2012_Client
call install.bat
C:\temp\package\TreeSizeFreeSetup.exe /SILENT