$INSTDIR=$args[0]

Function DownloadFile ($message, $file, $url)
{
  if((Test-Path $file) -eq 0) {
    echo $message
    Invoke-WebRequest $url -OutFile $file
  }
}

Function Expand-Zip($file, $destination)
{
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  if(!(Test-Path -Path "$fullDirName\$destination")){
    Set-Location $fullDirName
    New-Item -Type Directory -Name $destination
  }
  foreach($item in $zip.items()) {
    $shell.NameSpace("$fullDirName\$destination").copyhere($item, 0x14)
  }
}

$location = $pwd.Path
$tempDir = "OpenBazaar"
$fullDirName = "$env:temp\$tempDir"
$osType = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match "(x64)"
$wc = New-Object net.webclient

# Create temp directory
if(!(Test-Path -Path $fullDirName)){
  Set-Location $env:temp
  New-Item -Type Directory -Name $tempDir
}
Set-Location $fullDirName

# Download libsodium
Write-Host "Downloading libsodium..."
If (-Not(Test-Path -Path "$fullDirName\libsodium.zip")){
  $wc.Downloadfile("https://download.libsodium.org/libsodium/releases/libsodium-1.0.3-msvc.zip", "$fullDirName\libsodium.zip")
}

# Download .h files
Write-Host "Downloading header files..."
$wc.Downloadfile("http://msinttypes.googlecode.com/svn/trunk/inttypes.h", "$fullDirName\inttypes.h")
$wc.Downloadfile("http://msinttypes.googlecode.com/svn/trunk/stdint.h", "$fullDirName\stdint.h")

# Download pynacl
Write-Host "Downloading pynacl..."
If (-Not(Test-Path -Path "$fullDirName\pynacl.zip")){
  $wc.Downloadfile("https://github.com/pyca/pynacl/archive/v0.3.0.zip", "$fullDirName\pynacl.zip")
}

# Download Visual C++ Python
Write-Host "Downloading Visual C++ for Python..."
If (-Not(Test-Path -Path "$fullDirName\VCForPython27.msi")){
  $wc.Downloadfile("https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi", "$fullDirName\VCForPython27.msi")
}

# Download Python 2.7.x
Write-Host "Downloading Python..."
If (-Not(Test-Path -Path "$fullDirName\python-2.7.10.msi")){
  if ($os_type -eq "True") {
    $wc.Downloadfile("https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi", "$fullDirName\python-2.7.10.msi")
  } else {
    $wc.Downloadfile("https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi", "$fullDirName\python-2.7.10.msi")
  }
}

# Download Visual Studio Redistributable 2013
Write-Host "Downloading Visual Studio Redistributable..."
If (-Not(Test-Path -Path "$fullDirName\vcredist.exe")){
  if ($os_type -eq "True") {
    $wc.Downloadfile("http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe", "$fullDirName\vcredist.exe")
  } else {
    $wc.Downloadfile("http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe", "$fullDirName\vcredist.exe")
  }
}

# Download nodejs and electron-prebuilt
Write-Host "Downloading Node JS and Electron..."
If (-Not(Test-Path -Path "$fullDirName\node.msi")){
  if ($os_type -eq "True") {
    $wc.DownloadFile("https://nodejs.org/download/release/latest/node-v4.1.1-x64.msi", "$fullDirName\node.msi")
    $wc.DownloadFile("https://github.com/atom/electron/releases/download/v0.33.1/electron-v0.33.1-win32-x64.zip", "$fullDirName\electron.zip")
    $wc.DownloadFile("http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win-amd64-py2.7.exe/download", "$fullDirName\pywin32.exe")
  } else {
    $wc.DownloadFile("https://nodejs.org/download/release/latest/node-v4.1.1-x86.msi", "$fullDirName\node.msi")
    $wc.DownloadFile("https://github.com/atom/electron/releases/download/v0.33.1/electron-v0.33.1-win32-ia32.zip", "$fullDirName\electron.zip")
    $wc.DownloadFile("http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win32-py2.7.exe/download", "$fullDirName\pywin32.exe")
  }
}

# Extract libsodium
Write-Host "Extracting zip files..."
Expand-Zip -File "$fullDirName\libsodium.zip" -Destination "libsodium"

# Extract pynacl
Expand-Zip -File "$fullDirName\pynacl.zip" -Destination "pynacl"

# Install nodejs
Write-Host "Installing Node JS..."
Start-Process "$fullDirName\node.msi" -ArgumentList "/qn /passive" -Wait

# Install Python 2.7
Write-Host "Installing Python..."
Start-Process "$fullDirName\python-2.7.10.msi" -ArgumentList "TARGETDIR=$INSTDIR\python27 /passive" -Wait
Write-Host "Installing VC Redist..."
Start-Process "$fullDirName\vcredist.exe" -ArgumentList "/passive" -Wait
Write-Host "Installing VC for Python..."
Start-Process "$fullDirName\VCForPython27.msi" /qn -Wait
Write-Host "Installing pywin32..."
Start-Process "$fullDirName\pywin32.exe" -ArgumentList "/passive" -Wait

# Add python and scripts folder to PATH
Write-Host "Setting PATH Vars..."
[Environment]::SetEnvironmentVariable("PATH", "%PATH%;$INSTDIR\python27;$INSTDIR\python27\Scripts", "Process")
[Environment]::SetEnvironmentVariable("PATH", "%PATH%;$INSTDIR\python27;$INSTDIR\python27\Scripts", "User")

# Set environment variables
[Environment]::SetEnvironmentVariable("SODIUM_INSTALL", "system", "Process")
[Environment]::SetEnvironmentVariable("INCLUDE", "$fullDirName\libsodium\include", "Process")
if ($os_type -eq "True") {
  [Environment]::SetEnvironmentVariable("LIB", "$fullDirName\libsodium\x64\Release\v120\dynamic", "Process")
} else {
  [Environment]::SetEnvironmentVariable("LIB", "$fullDirName\libsodium\Win32\Release\v120\dynamic", "Process")
}

# Copy .h files to include folder
Write-Host "Copying header files into place..."
Copy-Item "$fullDirName\inttypes.h" "$fullDirName\libsodium\include"
Copy-Item "$fullDirName\stdint.h" "$fullDirName\libsodium\include"

# Copy and Rename libsodium.lib to sodium.lib
if ($os_type -eq "True") {
  Copy-Item "$fullDirName\libsodium\x64\Release\v120\dynamic\libsodium.lib" "$fullDirName\libsodium\x64\Release\v120\dynamic\sodium.lib"
} else {
  Copy-Item "$fullDirName\libsodium\win32\Release\v120\dynamic\libsodium.lib" "$fullDirName\libsodium\win32\Release\v120\dynamic\sodium.lib"
}

# Run python setup.py install
Write-Host "Installing pynacl..."
Set-Location "$fullDirName\pynacl\pynacl-0.3.0"
Start-Process "python" -ArgumentList "setup.py build" -NoNewWindow -Wait
Start-Process "python" -ArgumentList "setup.py install" -NoNewWindow -Wait

# Copy libsodium.dll to <Python>/Lib/site-packages/<pynacl>/nacl/_lib
if ($os_type -eq "True") {
  Copy-Item "$fullDirName\libsodium\x64\Release\v120\dynamic\libsodium.dll" "$INSTDIR\Python27\Lib\site-packages\PyNaCl-0.3.0-py2.7-win-amd64.egg\nacl\_lib"
} else {
  Copy-Item "$fullDirName\libsodium\win32\Release\v120\dynamic\libsodium.dll" "$INSTDIR\Python27\Lib\site-packages\PyNaCl-0.3.0-py2.7-win32.egg\nacl\_lib"
}

Start-Process "pip" -ArgumentList "install cffi" -NoNewWindow -Wait
#Start-Process "pip" -ArgumentList "install pywin32" -NoNewWindow -Wait

Set-Location "$env:localappdata\$tempDir\OpenBazaar-Server"
Start-Process "pip" -ArgumentList "install -r requirements.txt" -NoNewWindow -Wait

# Clean up temp dir
#Set-Location $env:temp\$tempDir
#Remove-Item *.* -Force
#Set-Location ..
#Remove-Item $tempDir
#Set-Location $location
