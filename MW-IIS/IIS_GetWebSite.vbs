'####Automation for website information collection from Web server####
'#### Created By Raghuraj Thiruvengadam####
On Error Resume Next
DIM CRLF, TAB,ObjFSO,objInputFile
DIM strServer,arrComputers,strComputers
DIM objWebService
DIM objWebServer, objWebServerRoot, strBindings
DIM myFSO
DIM WriteStuff
DIM tmp 
    
TAB  = CHR( 9 )
CRLF = CHR( 13 ) & CHR( 10 )

Set ObjFSO= createobject("Scripting.filesystemobject")
Set objInputFile = objFSO.openTextFile("Servers.txt", 1, True)

    Set WriteStuff = ObjFSO.OpenTextFile("SiteList.txt", 2, True)
    tmp = "Servername"&Vbtab&"Site ID"&vbTab&"Comment"&vbTab&"State"
    WriteStuff.WriteLine(tmp)
    
Do While objInputFile.AtEndOfLine <> True
		strServer = objInputFile.ReadLine
		
WScript.Echo "Enumerating websites on " & strServer & CRLF
SET objWebService = GetObject( "IIS://" & strServer & "/W3SVC" )
'EnumWebsites objWebService
'Next
'Loop

'SUB EnumWebsites( objWebService )

    FOR EACH objWebServer IN objWebService
        IF objWebserver.Class = "IIsWebServer" THEN
        SET objWebServerRoot = GetObject(objWebServer.adspath & "/root")
            tmp = strServer&vbTab&objWebserver.Name & vbTab & _
                objWebServer.ServerComment & vbTab & _
                State2Desc( objWebserver.ServerState ) '& "|" & _ 
                'objWebServerRoot.path & "|" & _ 
                'objWebServer.LogFileDirectory & "|" & _   
                'EnumBindings(objWebServer.ServerBindings) & "|" & _
        'EnumBindings(objWebServer.SecureBindings) & "|" & _
        
            WriteStuff.WriteLine(tmp)
        END IF
    NEXT
Loop
'END SUB

FUNCTION EnumBindings( objBindingList )
    DIM i, strIP, strPort, strHost
    DIM reBinding, reMatch, reMatches
    SET reBinding = NEW RegExp
    reBinding.Pattern = "([^:]*):([^:]*):(.*)"
    EnumBindings = ""
    FOR i = LBOUND( objBindingList ) TO UBOUND( objBindingList )
        ' objBindingList( i ) is a string looking like IP:Port:Host
        SET reMatches = reBinding.Execute( objBindingList( i ) )
        FOR EACH reMatch IN reMatches
            strIP = reMatch.SubMatches( 0 )
            strPort = reMatch.SubMatches( 1 )
            strHost = reMatch.SubMatches( 2 )



            ' Do some pretty processing
            IF strIP = "" THEN strIP = "All Unassigned"
            IF strHost = "" THEN strHost = "*"
            IF LEN( strIP ) < 8 THEN strIP = strIP & TAB

        EnumBindings = EnumBindings & strHost & "," & ""
        NEXT    
    NEXT
    if len(EnumBindings) > 0 Then EnumBindings = Left(EnumBindings,Len(EnumBindings)-1)
END FUNCTION



FUNCTION State2Desc( nState )
    SELECT CASE nState
    CASE 1
        State2Desc = "Starting (MD_SERVER_STATE_STARTING)"
    CASE 2
        State2Desc = "Started (MD_SERVER_STATE_STARTED)"
    CASE 3
        State2Desc = "Stopping (MD_SERVER_STATE_STOPPING)"
    CASE 4
        State2Desc = "Stopped (MD_SERVER_STATE_STOPPED)"
    CASE 5
        State2Desc = "Pausing (MD_SERVER_STATE_PAUSING)"
    CASE 6
        State2Desc = "Paused (MD_SERVER_STATE_PAUSED)"
    CASE 7
        State2Desc = "Continuing (MD_SERVER_STATE_CONTINUING)"
    CASE ELSE
        State2Desc = "Unknown state"
    END SELECT

END FUNCTION