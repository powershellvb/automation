Import-Module PDFTOOLS
.\STCVMAX1.ps1 | Out-File C:\Users\s0193253-A\Automation\STCVMAX1.txt
.\STCVMAX2.ps1 | Out-File C:\Users\s0193253-A\Automation\STCVMAX2.txt
.\STCVNX1.ps1 | Out-File C:\Users\s0193253-A\Automation\STCVNX1.txt
.\STCVNX2.ps1 | Out-File C:\Users\s0193253-A\Automation\STCVNX2.txt
.\STCIsilon.ps1 | Out-File C:\Users\s0193253-A\Automation\STCIsilon.txt
Get-Content .\STCVMAX1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCvmax1.pdf
Get-Content .\STCVMAX2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCvmax2.pdf
Get-Content .\STCVNX1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCVNX1.pdf
Get-Content .\STCVNX2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCVNX2.pdf
Get-Content .\STCIsilon.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\STCIsilon.pdf
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "STCSTORAGE@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "STC STORAGE Automated Monitoring." -body "STC STORAGE Automated Monitoring." -Attachments ".\STCvmax1.pdf",".\STCvmax2.pdf", ".\STCVNX1.pdf", ".\STCVNX2.pdf", ".\STCIsilon.pdf"