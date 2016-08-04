import-module XtremIO.Utils
$user= "admin"
$Pword = ConvertTo-SecureString -String "Xtrem10" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Connect-XIOServer -Credential $Credential -ComputerName 10.254.247.234 -port 443 -TrustAllCert
echo "=================================================================================================="
echo "						STC XIO Cluster Status					"
echo "=================================================================================================="
Get-XIOCluster | Select Name, SystemSN, SystemState, TotProvTB, TotSSDTB, UsedLogicalTB, UsedSSDTB, SizeAndCapacity, NumSSD, NumBrick, NumInfiniBandSwitch
echo "=================================================================================================="
echo "						STC XIO CONTROLLER Status				"
echo "=================================================================================================="
Get-XIODAEController | Select Name, Severity, ConnectivityState, Location, LifecycleState
echo "=================================================================================================="
echo "						STC XIO Disk Enclosure status				"
echo "=================================================================================================="
Get-XIODAEPsu | Select Name, Severity, LifecycleState, PowerFeed, PowerFailure, Location, Identification, Index
echo "=================================================================================================="
echo "						STC XIO INFIBAND SWITCH STATUS				"
echo "=================================================================================================="
Get-XIOInfinibandSwitch | Select Name, Severity, LifecycleState, FanDrawerStatus, FWVersionError
echo "=================================================================================================="
echo "						STC XIO CONTROLLER					"
echo "=================================================================================================="
Get-XIOStorageController | Select Name, LifecycleState, JournalState, State, Severity
echo "=================================================================================================="
echo "						STC XIO CONTROLLER POWERSUPPLY			"
echo "=================================================================================================="
Get-XIOStorageControllerPsu | Select Name, Severity, StatusLED, Location, Input, LifecycleState, PowerFeed, PowerFailure
echo "=================================================================================================="
echo "						STC XIO PERFOMANCE STATUS				"
echo "=================================================================================================="
Get-XIOClusterPerformance
echo "=================================================================================================="
echo "						STC XIO EVENTS						"
echo "=================================================================================================="
Get-XIOEvent | Select Category, DateTime, EventID, Severity, Description
Disconnect-XIOServer -ComputerName 10.254.247.234
