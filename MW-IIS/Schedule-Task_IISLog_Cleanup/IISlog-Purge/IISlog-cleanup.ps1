# ******
# Script for IIS log cleanup
# Tthis script will purge the iis logs which are more than 60 days.
# path will be vary to server to server, Hence that needs to be modified before schedule this script on server
# History:
# 07-26-2015: Original created by Thameem J
# ******

$limit = (Get-Date).AddDays(-60)
$path = "C:\inetpub\logs\LogFiles"

# Delete the folders and files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object {!$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
