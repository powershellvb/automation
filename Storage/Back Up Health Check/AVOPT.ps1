Import-Module PDFTOOLS
.\AVFOR.ps1 | Out-File C:\Users\s0193253-A\Automation\AVFOR.txt
.\AVMSP.ps1 | Out-File C:\Users\s0193253-A\Automation\AVMSP.txt
.\AVSTC.ps1 | Out-File C:\Users\s0193253-A\Automation\AVSTC.txt
Get-Content .\AVFOR.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\AVFOR.pdf -Autosize
Get-Content .\AVMSP.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\AVMSP.pdf -Autosize
Get-Content .\AVSTC.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\AVSTC.pdf -Autosize
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "Avamar@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org"  -cc "sselvaraj@stanfordhealthcare.org" -subject "Avamar Automate Monitoring" -body "Avamar Automate Monitoring." -Attachments ".\AVMSP.pdf", ".\AVFOR.pdf", ".\AVSTC.pdf"