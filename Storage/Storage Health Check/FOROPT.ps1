Import-Module PDFTOOLS
.\FORSANSW1.ps1 | Out-File C:\Users\s0193253-A\Automation\FORSANSW1.txt
.\FORSANSW2.ps1 | Out-File C:\Users\s0193253-A\Automation\FORSANSW2.txt
.\FORSANSW3.ps1 | Out-File C:\Users\s0193253-A\Automation\FORSANSW3.txt
.\FORSANSW4.ps1 | Out-File C:\Users\s0193253-A\Automation\FORSANSW4.txt
.\FORVNX1.ps1 | Out-File C:\Users\s0193253-A\Automation\FORVNX1.txt
.\FORVNX2.ps1 | Out-File C:\Users\s0193253-A\Automation\FORVNX2.txt
Get-Content .\FORSANSW1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORSANSW1.pdf
Get-Content .\FORSANSW2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORSANSW2.pdf
Get-Content .\FORSANSW3.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORSANSW3.pdf
Get-Content .\FORSANSW4.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORSANSW4.pdf
Get-Content .\FORVNX1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORVNX1.pdf
Get-Content .\FORVNX2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\FORVNX2.pdf
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "FORstorage@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "FOR Site Storage Automated Monitoring" -body "FOR Site Storage Automated Monitoring." -Attachments ".\FORSANSW1.pdf", ".\FORSANSW2.pdf", ".\FORSANSW3.pdf", ".\FORSANSW4.pdf", ".\FORVNX1.pdf", ".\FORVNX2.pdf"