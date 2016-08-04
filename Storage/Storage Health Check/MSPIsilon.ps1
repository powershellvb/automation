Import-Module SSH-Sessions
New-SshSession -ComputerName 10.254.216.12 -Username "root" -Password "a"
echo "=================================================================================================="
$SshSessions.'10.254.216.12'.Runcommand('isi status -q | grep "Cluster Name"').Result
echo "=================================================================================================="
echo "=================================================================================================="
echo "						ISILON CLUSTER STATUS				"
echo "=================================================================================================="
$SshSessions.'10.254.216.12'.Runcommand('isi status -q').Result
$SshSessions.'10.254.216.12'.Runcommand('isi batterystatus').Result
echo "=================================================================================================="
echo "						ISILON HARDDISK STATUS				"
echo "=================================================================================================="
$SshSessions.'10.254.216.12'.Runcommand('isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 1 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 3 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 4 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 5 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 6 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 7 isi devices -a status').Result
$SshSessions.'10.254.216.12'.Runcommand('isi_for_array -n 8 isi devices -a status').Result
echo "=================================================================================================="
echo "						ISILON NETWORK STATUS				"
echo "=================================================================================================="
$SshSessions.'10.254.216.12'.Runcommand('isi networks list pools -v').Result
echo "=================================================================================================="
echo "						ISILON EVENTS STATUS				"
echo "=================================================================================================="
$SshSessions.'10.254.216.12'.Runcommand('isi events list').Result
Remove-SshSession -RemoveAll