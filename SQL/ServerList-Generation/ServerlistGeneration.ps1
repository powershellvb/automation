
# SQL serverlist Generation
##  This script is used to generate the server list automatically and output servername will be in txt file

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy




cls
$Dev = "F:\Automation\ServerList\Dev.txt"

if (Test-Path $Dev) {
  Remove-Item $Dev
}

$Test = "F:\Automation\ServerList\Test.txt"

if (Test-Path $Test) {
  Remove-Item $Test
}

$DR = "F:\Automation\ServerList\DR.txt"

if (Test-Path $DR) {
  Remove-Item $DR
}

$Prod_Gold = "F:\Automation\ServerList\Prod_Gold.txt"

if (Test-Path $Prod_Gold) {
  Remove-Item $Prod_Gold
}

$Prod_Bronze = "F:\Automation\ServerList\Prod_Bronze.txt"

if (Test-Path $Prod_Bronze) {
  Remove-Item $Prod_Bronze
}

$Prod_Silver = "F:\Automation\ServerList\Prod_Silver.txt"

if (Test-Path $Prod_Silver) {
  Remove-Item $Prod_Silver
}


$Instances = "F:\Automation\ServerList\instances.txt"
if (Test-Path $Instances ){
  Remove-Item $Instances 
}
