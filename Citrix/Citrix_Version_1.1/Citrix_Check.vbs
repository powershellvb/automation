
Option Explicit
On Error Resume Next
Dim MailBodytext(2000)
Dim strMailto
Dim XLS_FILE
Dim strCompName
Dim strPath
Dim strFolder
Dim filePath
Dim TAB
Dim strComputer
Dim strKeyPath
Dim strValueName
Dim strDisabled
Dim strBootup
Dim strUptime 
Dim ObjFile
Dim objShell
Dim objFSO
Dim oReg
Dim objWMIDateTime
Dim objWMI
Dim colOS
Dim objOS
Dim arrcount
Dim srtline
Dim BodyText
Dim ForReading
Dim strSubject
Dim FontCol
Dim fcolor


XLS_FILE = "CitrixLogon_Result.xls"


Const strMailRelayHost = "smtp.stanfordmed.org"
' SMTP Relay hostname

Const strMailFromDomain = "_CTXLogonCheck@stanfordhealthcare.org"
' The script sends emails about it's actions, this is the FROM Address

strMailto = "skamalakannan@stanfordhealthcare.org;dl-hcl-wintel@stanfordhealthcare.org"
' The list of recipients we send the email message to' 

Const strMailtoScriptDown = "skamalakannan@stanfordhealthcare.org;dl-hcl-wintel@stanfordhealthcare.org"
'  strMailtoScriptDown 

strCompName = "Mail"


const HKEY_LOCAL_MACHINE = &H80000002 

Set objShell = CreateObject("Wscript.Shell")

strPath = Wscript.ScriptFullName

Set objFSO = CreateObject("Scripting.FileSystemObject")



if objfso.FileExists(XLS_FILE) then
	objfso.DeleteFile XLS_FILE
end if

Set objFile = objFSO.GetFile(strPath)

strFolder = objFSO.GetParentFolderName(objFile) 


IF WScript.Arguments.Length = 1 THEN
   
 filePath = WScript.Arguments( 0 )

filepath = strFolder & "\" & filepath

ELSE


 
filePath = strFolder & "\" & "Servers.txt"
if objfso.FileExists(filePath) then
else	
wscript.quit
end if
END IF


TAB  = VBTab


Set ObjFile = ObjFso.OpenTextFile(filePath)



MailBodytext(0) = "ServerName" & TAB & "Citrix Logon State"  & TAB & "Lastbootup" & TAB & "System Up Time" 
Writelog MailBodytext(0)

fcolor = "0000FF"

arrcount = 0
dim strHTML
strHTML = "<HTML>"
 strHTML = strHTML & "<HEAD>"
strHTML = strHTML & "<BODY>"
strHTML =  "<b> " & MailBodytext(0) & " </b></br>"
strHTML = strHTML &  "<font color=" & fcolor & ">"
Do Until ObjFile.AtEndOfStream

strHTML = strHTML &  "<font color=" & fcolor & ">"

strComputer = ObjFile.ReadLine

Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv") 
 strKeyPath = "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" 
 strValueName = "WinStationsDisabled" 
 oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,strDisabled 
 

If strDisabled = "0" Then 
 
  strDisabled = "Enabled"
else
strDisabled = "Disabled"
   End If



set objWMIDateTime = CreateObject("WbemScripting.SWbemDateTime")
set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
set colOS = objWMI.InstancesOf("Win32_OperatingSystem")
for each objOS in colOS
	objWMIDateTime.Value = objOS.LastBootUpTime

strBootup = objWMIDateTime.GetVarDate
strUptime = TimeSpan(objWMIDateTime.GetVarDate,Now)
	
next

arrcount = arrcount + 1

FontCol = "FF0000"

if strDisabled = "Enabled" then

MailBodytext(arrcount) = strcomputer & TAB & strDisabled & TAB & strBootup & TAB & strUptime 

Else

MailBodytext(arrcount) = strcomputer & TAB & "<font color=" & FontCol & ">" & strDisabled & TAB & strBootup & TAB & strUptime

end if

Writelog MailBodytext(arrcount)
strHTML = strHTML & MailBodytext(arrcount) & " </br>"
Loop

ObjFile.Close

Set ObjFile = ObjFso.OpenTextFile(XLS_FILE)



strHTML = strHTML & "</BODY>"
strHTML = strHTML & "</HTML>"

'SendMail "Reboot Script Finishing", "Reboot Script Finishing - Expected time is 5 minutes for reboot to complete.  If this does not occur, please look into the issue."






Sub writeLog(strText)
  Dim objFSO, objLogFile

  Set objFSO = CreateObject("Scripting.FileSystemObject")  
  Set objLogFile = objFSO.OpenTextFile(XLS_FILE, 8, True)

  objLogFile.WriteLine strText
  objLogFile.Close
  Set objLogFile = Nothing
  Set objFSO = Nothing

End Sub

Function TimeSpan(dt1, dt2) 

Dim seconds,minutes,hours
	' Function to display the difference between
	' 2 dates in hh:mm:ss format
	If (isDate(dt1) And IsDate(dt2)) = false Then 
		TimeSpan = "00:00:00" 
		Exit Function 
        End If 
 
        seconds = Abs(DateDiff("S", dt1, dt2)) 
        minutes = seconds \ 60 
        hours = minutes \ 60 
        minutes = minutes mod 60 
        seconds = seconds mod 60 
 
        if len(hours) = 1 then hours = "0" & hours 
 
        TimeSpan = hours & ":" & _ 
            RIGHT("00" & minutes, 2) & ":" & _ 
            RIGHT("00" & seconds, 2) 
End Function




strSubject = "Citrix Server_ Reboot_List_Status"
'*** Send SMTP eMail
'Function SendMail(strSubject,strBody)
Dim objEmail
Set objEmail = CreateObject("CDO.Message")
ObjEmail.HTMLBody = strHTML
objEmail.From = StrCompName & strMailFromDomain
objEmail.To = strMailTo
objEmail.Subject = strSubject
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
        strMailRelayHost 
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
objEmail.Configuration.Fields.Update
objEmail.AddAttachment strFolder & "\" & XLS_FILE
objEmail.Send
'End Function

set strFolder = Nothing
