$serverList = gc -path .\servers.txt
$app_sw = gc -path .\application_switch.txt
foreach ($server in $serverList)
{
	robocopy.exe "D:\s0187593\Automation\sprint 1\Task 3\Package" "\\$server\C$\temp\package" /COPYALL /SEC /E /ZB /TEE /R:1 /W:1 /DCOPY:T
	psexec \\$server cmd /c $app_sw
	Remove-Item -Path \\$server\c$\temp\package -force -Recurse
}