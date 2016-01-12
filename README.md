[![Slack Status](https://openbazaar-slackin-drwasho.herokuapp.com/badge.svg)](https://openbazaar-slackin-drwasho.herokuapp.com)

# OpenBazaar-Installer

In this repository we'll have the scripts necessary to create binary distributions for different operating systems.
The goal here is to have a 1-step build process.

You need of the follow dependencies:

 - wine
 - nodejs (npm executable) 
 - grunt
 - grunt-electron-debian-installer

(optional) upx and ucl to optimize standalone executable

Install them on brew (OSX) or do a query on
your Linux package manager.

This repository is not to install the software, but to BUILD the installer itself. We will make downloadable installer executables available at https://openbazaar.org.

This creation script has only been tested running on OS X Yosemite, Windows 10 and Ubuntu 14.04.

## Linux

* ./make_openbazaar.sh linux64 (64-bit)
* ./make_openbazaar.sh linux32 (32-bit)

## Windows

To build the Windows installer on Linux and OSX you can run:

* sh make_openbazaar.sh win32 (32-bit)
* sh make_openbazaar.sh win64 (64-bit)

## OSX

./make_openbazaar.sh osx
