Import-Module Posh-SSH
$user= "admin"
$Pword = ConvertTo-SecureString -String "Admin#123" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$FORAVssh=Posh-SSH\New-SSHSession -ComputerName 10.243.83.82 -Credential $Credential
$s=$(Invoke-SshCommand -SSHSession $FORAVssh -Command "status.dpn").output
$w=$(Invoke-SshCommand -SSHSession $FORAVssh -Command "dpnctl status").output
$t=$(Invoke-SshCommand -SSHSession $FORAVssh -Command "mccli server show-prop").output
$u=$(Invoke-SshCommand -SSHSession $FORAVssh -Command "avmaint nodelist | grep -i fs-perc").output
#$w=$(Invoke-SshCommand -SSHSession $FORAVssh -Command "dpnctl status").output
#$v=$(Invoke-SshCommand -SSHSession $STCAVssh -Command "./2replcnt.pl --dpnname=shavampscsu401-01.enterprise.stanfordmed.org --dstaddr=10.254.216.191 --dstid=repluser --dstpassword=changeme1 --showall").output
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
Remove-SSHSession -SSHSession $FORAVssh
Remove-variable FORAVssh



