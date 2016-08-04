Const Reading = 1
Dim objComp, strcomputer
Dim objExcel, objWorkbook, objWorksheet, objGroup, objRange
Dim objfile, objNtpad

Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = True
Set objWorkbook = objExcel.Workbooks.Add()
Set objWorksheet = objWorkbook.Worksheets(1)
Set objNtpad = CreateObject("Scripting.FileSystemObject")
Set objFile = objNtpad.OpenTextFile("D:\s0187593\Servers.txt", Reading)

On Error Resume Next
Set objexcel=CreateObject("Excel.application")
If(number <> 0) Then
  On Error Goto 0
  WScript.Echo "Excel application not found"
  WScript.Quit
End If
objworksheet.cells(1,1) = "Servername"
objworksheet.cells(1,2) = "Members of Admin Group"
objworksheet.range("A1:B1").font.size= 12
objworksheet.range("A1:B1").font.bold= True
x = 2
Do
strComputer = objfile.ReadLine
Set objComp = GetObject("WinNT://" & strComputer) 
objComp.GetInfo  
If objComp.PropertyCount > 0 Then
    Set objGroup = GetObject("WinNT://" & strComputer & "/Administrators,group")
    If objGroup.PropertyCount > 0 Then
       objworksheet.cells(x, 1)=  strcomputer
         n = 2
        For Each mem In objGroup.Members
        objworksheet.cells(x, n) = Right(mem.adsPath, Len(mem.adspath) - 8) 
          x = x + 1 
         Next
End If
   x = x + 1
End If
  
Loop Until objfile.AtEndOfStream = True
Set objrange = objWorksheet.Usedrange
objrange.entirecolumn.autofit()
objworkbook.SaveAs "C:\Temp\LocalAdmin_groups.xls"

WScript.Echo "File saved successfully on C:\Temp\LocalAdmin_groups.xls"
Set objworksheet = Nothing
Set objworkbook = Nothing
Set objexcel = Nothing
Set objfile = Nothing
Set objrange = Nothing