$tempDir = "OpenBazaar"
$fullDirName = "$env:localappdata\$tempDir"

# Start System Tray Icon
Set-Location "$env:localappdata\$tempDir"
Start-Process "pythonw" -ArgumentList "systray.py" -NoNewWindow

Set-Location "$env:localappdata\$tempDir\OpenBazaar-Client"

# Start openbazaard
Start-Process "pythonw" -ArgumentList "$fullDirName\OpenBazaar-Server\openbazaard.py start" -NoNewWindow

# Start Electron client
Start-Process "npm" -ArgumentList "install" -NoNewWindow -Wait
Start-Process "npm" -ArgumentList "start"
