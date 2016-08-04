
# Email  notification when database server goes down  Script.
#
#  This script  is used to ping all the servers if any of the server is down automatically send an mail to our DL. .

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy

$InputFile = "F:\Automation\DbList\All.txt"
Function Test-SQLConn ($Server)
{
    $connectionString = "Data Source=$Server;Integrated Security=true;Initial Catalog=master;Connect Timeout=10;"
    $sqlConn = new-object ("Data.SqlClient.SqlConnection") $connectionString
    trap
    {
        Write-output "$instance Cannot connect.";
        send-mailmessage -from "DL-HCL-SQL@stanfordhealthcare.org" -to "DL-HCL-SQL@stanfordhealthcare.org" -subject "Server Down::$instance" -body "Server Down::$instance. DBA Team Check the status of the same." -smtpServer smtp.stanfordmed.org
        continue
    }
    $sqlConn.Open()
    if ($sqlConn.State -eq 'Open')
    {
            $sqlConn.Close();
    }
}

ForEach ($instance in Get-Content $InputFile)
{
Test-SQLConn -server $instance
}