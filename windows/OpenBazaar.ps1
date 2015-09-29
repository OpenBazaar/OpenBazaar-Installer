$tempDir = "OpenBazaar"
$fullDirName = "$env:localappdata\$tempDir"

Set-Location "$env:localappdata\$tempDir\OpenBazaar-Client"

Start-Process "python" -ArgumentList "$fullDirName\OpenBazaar-Server\openbazaard.py start" -NoNewWindow

Start-Process "npm" -ArgumentList "install" -NoNewWindow -Wait
Start-Process "npm" -ArgumentList "start"
