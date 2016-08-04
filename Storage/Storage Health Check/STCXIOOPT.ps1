Import-Module PDFTOOLS
.\STCXIO.ps1 | Out-File C:\Users\s0193253-A\Automation\STCXIO.txt
Get-Content .\STCXIO.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCXIO.pdf
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "dl-hcl-storage@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "STC xTremeIO Automated Monitoring" -body "STC xTremeIO Autoamated Monitoring." -Attachments ".\STCXIO.pdf"