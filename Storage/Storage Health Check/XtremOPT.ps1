Import-Module PDFTOOLS
.\STCXIO.ps1 | Out-File C:\Users\s0193253-A\Automation\STCXIO.txt
.\MSPXIO2.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPXIO2.txt
.\MSPXIO1.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPXIO1.txt
Get-Content .\STCXIO.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCXIO.pdf -Autosize
Get-Content .\MSPXIO2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPXIO2.pdf -Autosize
Get-Content .\MSPXIO1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPXIO1.pdf -Autosize
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "XtremIO@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "MSP and STC XTREMEIO Automate Monitoring" -body "MSP and STC XTREMEIO Automate Monitoring." -Attachments ".\STCXIO.pdf", ".\MSPXIO2.pdf", ".\MSPXIO1.pdf"