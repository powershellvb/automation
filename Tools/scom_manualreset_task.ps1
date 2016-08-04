<#


	scom-manual-monitor-reset.ps1
   

	The script iterates through the state hierarchy of each monitoring
	object in the management group and resets all "manual reset" monitors
	that have been in "Error" or "Warning" state longer than the specified 
	max period for time in state.

        The script is intended to run as a scheduled task. 

	$MaxTimeInState - defines delay for resetting a manual reset monitor in hours

     

#>


Import-Module OperationsManager


$MaxTimeInState = 24
$count_items = 0
$count_resets = 0
$count_errors = 0

$eventSource = "SCOM Monitor Reset Script"
$eventLog = "Operations Manager"

$st_success = [Microsoft.EnterpriseManagement.Configuration.HealthState]::Success
$st_error = [Microsoft.EnterpriseManagement.Configuration.HealthState]::Error
$st_warning = [Microsoft.EnterpriseManagement.Configuration.HealthState]::Warning

if ( [System.Diagnostics.EventLog]::SourceExists( $eventSource ) -eq $false )
{  [System.Diagnostics.EventLog]::CreateEventSource( $eventSource , $eventLog ) }


function log( $msg, $eventID = 100, $lvl = "Information"  )
{ Write-EventLog -LogName $eventLog -Source $eventSource -eventID $eventID -entryType $lvl -message $msg }



############################

function IsManualResetMonitor( $m )
{
  if ( $m.OperationalStateCollection ) 
  {
    foreach( $state in $m.OperationalStateCollection )
    {
   	        if ( ( $state.HealthState -eq $st_success ) `
              -and ( $state.GetUnitMonitorTypeState().NoDetection ) ) 
                { return $true }
    }

   }
   return $false
}


#################################

function CheckManualReset( $node )
{
    $script:count_items += 1
    try
    {
       if ( $node -and ( $st_warning, $st_error -icontains $node.Item.HealthState ))
       {
           $monitor = Get-SCOMMonitor -id $node.Item.MonitorId

           if ( IsManualResetMonitor( $monitor ) )
           {
               $obj = Get-SCOMMOnitoringObject -id $node.Item.MonitoringObjectId
               
               $TimeInState = [math]::Round( ([DateTime]::Now - $node.Item.LastTimeModified).TotalHours, 0 )

               if ($TimeInState -gt $MaxTimeInState )
               {
                    $script:count_resets += 1
               	    Log $( 'Manual reset monitor "{0}:{1}" has been in {2} state for {3} hours. Monitor state will now be reset.' `
                       -F $obj.DisplayName, $monitor.DIsplayName, $node.Item.HealthState, $TimeInState ) 104
    	   	        
        		   $task = $node.Item.Reset( 60000 ) 
        		   if ( $task.ErrorCode -ne 0 ) 
        	   	   {
        			    Log $( 'Failed to reset monitor "{0}". Error code {1}: {2}' `
                          -F $monitor.DisplayName, $task.ErrorCode, $task.ErrorMessage ) 301 Warning
        	        	$script:count_errors += 1
        	   	   }
    	       }
           }
       }


        foreach( $child in $node.ChildNodes )
         { CheckManualReset( $child ) }

    }
    catch
    {
        $script:count_errors += 1
        Log $("Error prosessing monitor state ($node.Item.MonitorDisplayName): $_") 501 Warning
    }
}



############### main  ###################


try
{
   Log "Monitor reset task starting"

   Get-SCOMMonitoringObject | `
     foreach-object{ CheckManualReset( $_.GetMonitoringStateHierarchy() ) }
     
   Log $("Finished processing $count_items items with $count_resets resets and $count_errors errors") 105 
}
catch
{
    Log $("Unhandled exception: " + $_) 500 Error 
}