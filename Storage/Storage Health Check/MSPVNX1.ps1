echo off
echo "=========================================================================================================================="
echo "						MSP ARRAYNAME DETAILS								"
echo "=========================================================================================================================="

cmd /c naviseccli -h 10.254.132.82 getall | find "Array Name"

cmd /c naviseccli -h 10.254.132.82 getagent | find "Serial No"

echo "=========================================================================================================================="
echo "						MSP VNX POOL SPACE DETAILS								"
echo "=========================================================================================================================="

cmd /c naviseccli -h 10.254.132.82 storagepool -list -availableCap -consumedCap -UserCap -prcntFull | findstr "Pool GBs percent"

echo "=========================================================================================================================="
echo "						MSP VNX RAIDGROUP SPACE DETAILS								"
echo "=========================================================================================================================="

cmd /c naviseccli -h 10.254.132.82 getrg -disks -legal -hotspare -tcap | findstr "RaidGroup Legal Logical Capacity"


echo "=========================================================================================================================="
echo "						MSP VNX HEALTH STATUS								"
echo "=========================================================================================================================="

cmd /c naviseccli -h 10.254.132.82 faults -list

cmd /c naviseccli -h 10.254.132.83 faults -list


echo "=========================================================================================================================="
echo "						MSP VMAX EVENTS									"
echo "=========================================================================================================================="

cmd /c naviseccli -h 10.254.132.82 getlog -30

cmd /c naviseccli -h 10.254.132.83 getlog -40
