Import-Module PDFTOOLS
.\DDMSP1.ps1 | Out-File C:\Users\s0193253-A\Automation\DDMSP1.txt
.\DDMSP2.ps1 | Out-File C:\Users\s0193253-A\Automation\DDMSP2.txt
.\DDSTC2.ps1 | Out-File C:\Users\s0193253-A\Automation\DDSTC2.txt
.\DDSTC1.ps1 | Out-File C:\Users\s0193253-A\Automation\DDSTC1.txt
.\DDFOR.ps1 | Out-File C:\Users\s0193253-A\Automation\DDFOR.txt
Get-Content .\DDMSP1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\DDMSP1.pdf -Autosize
Get-Content .\DDMSP2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\DDMSP2.pdf -Autosize
Get-Content .\DDSTC2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\DDSTC2.pdf -Autosize
Get-Content .\DDSTC1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\DDSTC1.pdf -Autosize
Get-Content .\DDFOR.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\DDFOR.pdf -Autosize
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "DDMSP@stanfordhealthcare.org" -to "DL-HCL-Backup@stanfordhealthcare.org"  -cc "sselvaraj@stanfordhealthcare.org" -subject "All locations Data Domain Automate Monitoring" -body "All locations Data Domain Automate Monitoring." -Attachments ".\DDMSP1.pdf", ".\DDMSP2.pdf", ".\DDSTC2.pdf", ".\DDSTC1.pdf", ".\DDFOR.pdf"