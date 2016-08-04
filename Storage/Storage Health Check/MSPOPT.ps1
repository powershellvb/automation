Import-Module PDFTOOLS
.\MSPVMAX1.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPVMAX1.txt
.\MSPVMAX2.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPVMAX2.txt
.\MSPVNX1.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPVNX1.txt
.\MSPVNX2.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPVNX2.txt
.\MSPIsilon.ps1 | Out-File C:\Users\s0193253-A\Automation\MSPIsilon.txt
Get-Content .\MSPVMAX1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPvmax1.pdf
Get-Content .\MSPVMAX2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPvmax2.pdf
Get-Content .\MSPVNX1.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPVNX1.pdf
Get-Content .\MSPVNX2.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPVNX2.pdf
Get-Content .\MSPIsilon.txt | Out-PTSPDF C:\Users\s0193253-A\Automation\MSPIsilon.pdf
$PSEmailServer = "outlook-stc2.stanfordmed.org"
send-mailmessage -from "MSPSTORAGE@stanfordhealthcare.org" -to "dl-hcl-storage@stanfordhealthcare.org" -subject "MSP Storage Automated Monitoring" -body "MSP Storage VMAX Automated Monitoring." -Attachments ".\MSPvmax1.pdf", ".\MSPvmax2.pdf", ".\MSPVNX1.pdf", ".\MSPVNX2.pdf", ".\MSPIsilon.pdf"