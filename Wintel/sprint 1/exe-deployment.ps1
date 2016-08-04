$serverList = 'shwintpscju102'

foreach ($server in $serverList)

{


	robocopy.exe "D:\s0187593\Automation\sprint 1\Task 3\Package" "\\$server\C$\temp\package" /COPYALL /SEC /E /ZB /TEE /R:1 /W:1 /DCOPY:T
	psexec \\$server -i -w C:\temp\package cmd.exe /c "D:\s0187593\Automation\sprint 1\Task 3\silentinstall.bat"
	
}