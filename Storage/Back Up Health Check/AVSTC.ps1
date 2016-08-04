Import-Module Posh-SSH
$user= "admin"
$Pword = ConvertTo-SecureString -String "changeme1" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$AVSTCssh=Posh-SSH\New-SSHSession -ComputerName 10.248.216.191 -Credential $Credential
$s=$(Invoke-SshCommand -SSHSession $AVSTCssh -Command "status.dpn").output
$t=$(Invoke-SshCommand -SSHSession $AVSTCssh -Command "mccli server show-prop").output
$u=$(Invoke-SshCommand -SSHSession $AVSTCssh -Command "avmaint nodelist | grep -i fs-perc").output
$w=$(Invoke-SshCommand -SSHSession $AVSTCssh -Command "dpnctl status").output
#$v=$(Invoke-SshCommand -SSHSession $AVSTCssh -Command "./2replcnt.pl --dpnname=shavampscsu401-01.enterprise.stanfordmed.org --dstaddr=10.254.216.191 --dstid=repluser --dstpassword=changeme1 --showall").output
echo "=================================================================================================="
echo "						AVAMAR STATUS						"
echo "=================================================================================================="
$s
echo "=================================================================================================="
echo "						AVAMAR SERVICE STATUS					"
echo "=================================================================================================="
$w
echo "=================================================================================================="
echo "						AVAMAR HARDWARE ALERTS					"
echo "=================================================================================================="
$t
echo "=================================================================================================="
echo "						AVAMAR NODE STATUS					"
echo "=================================================================================================="
$u
#$v
Remove-SSHSession -SSHSession $AVSTCssh
Remove-variable AVSTCssh



