'================================
'Author: Mircea Sirghi, hakkussg@gmail.com, www.linkedin.com/pub/mircea-sirghi/32/6b5/700/
'================================

Option Explicit

RegisterUserFunc "Browser", "WaitForPageToLoad", "WaitForPageToLoad"
RegisterUserFunc "Browser", "evalJS", "evalJS"
RegisterUserFunc "Browser", "ActivateBrowser", "ActivateBrowser"
RegisterUserFunc "Browser", "BrowserMaximize", "BrowserMaximize"
RegisterUserFunc "Browser", "BrowserMinimize", "BrowserMinimize"

'================================
'Description : Function used to open a browser
'Arguments  :  browserType(String) -- Type of the Browser like IE, Firefox, Chrome
'================================
Function openBrowser(ByVal browserType)
	gLogger.LogFunctionStart("openBrowser")
	Select Case browserType
		Case "IE"
			SystemUtil.Run "iexplore", "", "", ""
			With Browser("CreationTime:=0")
			    If Browser("IEBrowser").Dialog("Internet Explorer 11").Exist(1) Then
			    	Browser("IEBrowser").Dialog("Internet Explorer 11").WinRadioButton("Don’t use recommended").Click
			    	Browser("IEBrowser").Dialog("Internet Explorer 11").WinButton("OK").Click
				End If    
			End With
			gLogger.LogWrite("IE browser started.")
		Case Else 
			call gLogger.LogException("openBrowser", "There is no such browser type ["& browserType &"].")
	End Select	
	gLogger.LogFunctionEnd("openBrowser")
End Function
'================================

'================================
'Description : Function used to close all opened browsers of a specific type
'Arguments  :  browserType(String) -- Type of the Browser like IE, Firefox, Chrome
'================================
Function closeBrowser(ByVal browserType)
	gLogger.LogFunctionStart("closeBrowser")
	Select Case browserType
		Case "IE"
			SystemUtil.CloseProcessByName "iexplore.exe"
			gLogger.LogWrite("IE browser closed.")
		Case Else 
			call gLogger.LogException("closeBrowser", "There is no such browser type ["& browserType &"].")
	End Select	
	gLogger.LogFunctionEnd("closeBrowser")
End Function
'================================

'StrURL = InputBox("Enter the URL")
'Call InvokeIE(StrURL)
'
'Function InvokeIE(URL)
'       SET IEObj = CreateObject("InternetExplorer.Application")
'       IEObj.Navigate URL
'       IEObj.Visible = True
'       SET IEObj = Nothing
'End Function

'Function WaitForPageToLoad(objBrowser)
'	Dim Object
'	Dim objReadyState	
'	objBrowser.Sync
'	Set objReadyState = objBrowser.Object
'	Dim i:i=0
'	
'	gLogger.LogWrite(objReadyState.readyState)
'	
'	Do While objReadyState.readyState <> "complete"
'		i = i+1
'		If(i>10)Then
'			Exit Do
'		Else	
'			Wait 1
'		End If
'	Loop
'	Set Object=nothing
'	
'	gLogger.LogWrite(objReadyState.readyState)
'	i=0
'	Set Object=objBrowser.object	
'	Do While Object.Busy=True
'		i = i+1
'		If(i>10)Then
'			Exit Do
'		Else	
'			Wait 1
'		End If
'	Loop
'	
'	gLogger.LogWrite(objReadyState.readyState)
'	Set Object=nothing
'End Function


'================================
'Description : Function used to execute javascript code in QTP
'Arguments   : obrowser(Browser)
'            : sJavaScript(String) javascript code to be executed
'Source      : http://www.softwareinquisition.com/81.htm
'================================
Public Function evalJS(oBrowser, sJavaScript, bSeverity)
	Dim fname:fname = "evalJS"	
	'gLogger.LogFunctionStart(fname)
	
	evalJS = ""
	Dim JSEntry
	Set JSEntry = oBrowser.object.document.documentelement.parentnode.parentwindow
	
	Err.Number = 0
	
	On Error Resume Next
	evalJS = JSEntry.eval(sJavaScript)
	
	'Call gLogger.LogWrite("evalJs Value ["&evalJS&"]")
	If(Err.Number <> 0 And bSeverity = true)Then
		Call gLogger.LogException(fname, "Error occured while running the javascript code : [" & sJavaScript & "]")
	End IF

	On Error Goto 0
	
	'gLogger.LogFunctionEnd(fname)
End Function
'================================

'================================
'Description : Function used to make QTP wait till the page content is loaded
'Arguments   : obrowser(Browser)
'Author: Mircea Sirghi(hakkussg@gmail.com, www.linkedin.com/pub/mircea-sirghi/32/6b5/700/)
'================================
Function WaitForPageToLoad(oBrowser)
	Dim fname:fname = "evalJS"	
	gLogger.LogFunctionStart(fname)
	Dim i:i=0
	Dim completed:completed=false
	
	Dim javaScriptCode
	
	javaScriptCode = " function test()" _
				& " {" _
				& " return document.readyState;" _ 
				& " }" _
				& " test();"
	Do 
		Wait 1
		i=i+1
		If((StrComp(evalJS(oBrowser, javaScriptCode, false),"complete") = 0) OR (StrComp(evalJS(oBrowser, javaScriptCode, false),"interactive") = 0))Then
			completed = true
			Exit Do
		End If
	Loop While i<30
	
	Dim testVal:testVal = evalJS(oBrowser, javaScriptCode, true)
	
	gLogger.LogWrite("evaluation complete value is [" & testVal & "]")
	
	If(completed <> true)Then
		Call gLogger.LogWarning(fname, "The page completed state is not 'complete' it might be that the test have run while the page was not completely loaded.")
	End If	
	gLogger.LogFunctionEnd(fname)
End Function
'================================

'================================
'Description : Function used to activate the browser window
'Arguments   : obrowser(Browser)
'Source      : https://automationlab09.wordpress.com/tag/maximize-browser-in-qtp/
'================================
Function ActivateBrowser(oBrowser)

Dim hWnd

hWnd=oBrowser.GetROProperty("hwnd")

hWnd = Browser("hwnd:=" & hWnd).Object.hWnd

Window("hwnd:=" & hWnd).Activate

End Function
'================================

'================================
'Description : Function used to maximize the browser window
'Arguments   : obrowser(Browser)
'Source      : https://automationlab09.wordpress.com/tag/maximize-browser-in-qtp/
'================================
Function BrowserMaximize(oBrowser)

Dim hWnd

hWnd=oBrowser.GetROProperty("hwnd")

hWnd = Browser("hwnd:=" & hWnd).Object.hWnd

Window("hwnd:=" & hWnd).Activate

Window("hwnd:=" & hWnd).Maximize

End Function
'================================

'================================
'Description : Function used to minimize the browser window
'Arguments   : obrowser(Browser)
'Source      : https://automationlab09.wordpress.com/tag/maximize-browser-in-qtp/
'================================
Function BrowserMinimize(oBrowser)

Dim hWnd

hWnd=oBrowser.GetROProperty("hwnd")

hWnd = Browser("hwnd:=" & hWnd).Object.hWnd

Window("hwnd:=" & hWnd).Activate

Window("hwnd:=" & hWnd).Minimize

End Function
'================================