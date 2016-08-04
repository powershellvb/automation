Import-Module Posh-SSH
New-SshSession -ComputerName 10.248.132.71 -Username "S0191806-A" -Password "Storage@123"
Invoke-SshCommand -Index 0 -Command "show env"