# OpenBazaar-Installer

In this repository we'll have the scripts necessary to create binary distributions for different operating systems.
The goal here is to have a 1-step build process.

This repository is not to install the software, but to BUILD the installer itself. We will make downloadable installer executables available at https://openbazaar.org.

This creation script has only been tested running on OS X Yosemite.

## Linux

sh make_openbazaar.sh linux

## Windows

To build the Windows installer on Linux and OSX you can run:

* sh make_openbazaar.sh win32 (32-bit)
* sh make_openbazaar.sh win64 (64-bit)

Remember to clear out the temp/ folder before building a different architecture

## OSX

sh make_openbazaar.sh osx
