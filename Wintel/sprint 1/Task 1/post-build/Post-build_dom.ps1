param(
	$Step="A"
#	[Parameter(Position=0,ValuefromPipeline=$true)][string][alias("cn")]$computer,
#	[Parameter(Position=1,ValuefromPipeline=$false)][string]$NewName
)
# -------------------------------------
# Imports
# -------------------------------------
$script = $myInvocation.MyCommand.Definition
$scriptPath = Split-Path -parent $script
. (Join-Path $scriptpath functions.ps1)


Clear-Any-Restart

if (Should-Run-Step "A") 
{
	$domain = "enterprise.stanfordmed.org"
	$username = "$domain\s0187593-a" 
	$File = "C:\Temp\post-build\secure.txt"
	$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (Get-Content $File | ConvertTo-SecureString)
	Add-Computer -DomainName $domain -Credential $mycredential
	Restart-And-Resume $script "B"
}

if (Should-Run-Step "B") 
{
    Start-Process -FilePath C:\temp\post-build\app_ins.bat -windowstyle Hidden
}

#if (Should-Run-Step "C") 
#{
#	Write-Host "C"
#}

Wait-For-Keypress "postbuild activity Complete, press any key to exit script..."