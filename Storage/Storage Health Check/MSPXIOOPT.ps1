Import-Module PDFTOOLS
.\MSPXIO1.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPXIO1.txt
.\MSPXIO2.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPXIO2.txt
Get-Content .\MSPXIO1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPXIO1.pdf
Get-Content .\MSPXIO2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPXIO2.pdf
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "dl-hcl-storage@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "MSP xTremeIO Automated Monitoring" -body "MSP xTremeIO Autoamated Monitoring." -Attachments ".\MSPXIO1.pdf", "MSPXIO2.pdf"