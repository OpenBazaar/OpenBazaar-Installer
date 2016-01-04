#!/bin/bash

## Version 0.1.0
##
## Usage
## ./make_openbazaar.sh OS
##	
## OS supported:
## win32 win64 linux osx
##

ELECTRONVER=0.36.2
NODEJSVER=5.1.1
PYTHONVER=2.7.11
UPXVER=391

OS="${1}"

# Check if user specified repository to pull code from

clone_url_server="https://github.com/OpenBazaar/OpenBazaar-Server.git"
clone_url_client="https://github.com/OpenBazaar/OpenBazaar-Client.git"

command_exists () {
    if ! [ -x "$(command -v $1)" ]; then
 	echo "$1 is not installed." >&2
    fi
}

clone_command() {
    if git clone ${clone_url_server} -b ${branch}; then
        echo "Cloned OpenBazaar Server successfully"
    else
        echo "OpenBazaar encountered an error and could not be cloned"
        exit 2
    fi
}

clone_command_client() {
    if git clone ${clone_url_client}; then
        echo "Cloned OpenBazaar Client successfully"
    else
        echo "OpenBazaar encountered an error and could not be cloned"
        exit 2
    fi
}

if ! [ -d OpenBazaar-Client ]; then
	echo "Cloning OpenBazaar-Client"
	clone_command_client
else
        cd OpenBazaar-Client
        git pull
        cd .. 

fi     

if [ -z "${dir}" ]; then
    dir="."
fi
cd ${dir}
echo "Switched to ${PWD}"

# Check for temp-$OS folder and create if does not exist
mkdir -p temp-$OS

command_exists grunt
command_exists npm
command_exists wine

# Download OS specific installer files to package
case $OS in win32*)
        export OB_OS=win32
	mkdir -p temp-$OS
	branch=noupnp
	if ! [ -d OpenBazaar-Server ]; then
		echo "Cloning OpenBazaar-Server"
		clone_command 
	else
        	cd OpenBazaar-Server
        	git pull
	        cd .. 
	fi    
	
        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
	npm install assert-plus

        echo 'Packaging Electron application'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=ia32 --version=${ELECTRONVER} --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp-$OS/OpenBazaar_Client-win32-ia32 temp-$OS/OpenBazaar-Client
	rm -rf temp-$OS/OpenBazaar-Client/OpenBazaar_Client-win32-ia32

        echo 'Downloading installers'

        cd temp-$OS
	
	if [ ! -f upx${UPXVER}w.zip ]; then
            wget http://upx.sourceforge.net/download/upx${UPXVER}w.zip -O upx.zip
	    unzip -o -j upx.zip
        fi

        if [ ! -f python-${PYTHONVER}.msi ]; then
            wget https://www.python.org/ftp/python/${PYTHONVER}/python-${PYTHONVER}.msi -O python-${PYTHONVER}.msi
        fi

        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe -O vcredist.exe
        fi

        if [ ! -f pynacl ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win32.egg.zip -O pynacl_win32.zip && unzip -o pynacl_win32.zip && rm pynacl_win32.zip
        fi

        cd ..

        makensis windows/ob.nsi
        ;;
    win64*)
        export OB_OS=win64
	mkdir -p temp-$OS
	branch=noupnp
	if ! [ -d OpenBazaar-Server ]; then
		echo "Cloning OpenBazaar-Server"
		clone_command
	else
        	cd OpenBazaar-Server
        	git pull
	        cd ..     
	fi    

        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
        npm install assert-plus
	
        echo 'Packaging Electron application'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=x64 --version=${ELECTRONVER} --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp-$OS/OpenBazaar_Client-win32-x64 temp-$OS/OpenBazaar-Client
	rm -rf temp-$OS/OpenBazaar-Client/OpenBazaar_Client-win32-x64

        echo 'Downloading installers'
        cd temp-$OS/
	
	if [ ! -f upx${UPXVER}w.zip ]; then
            wget http://upx.sourceforge.net/download/upx${UPXVER}w.zip -O upx.zip
	    unzip -o -j upx.zip
        fi

        if [ ! -f python-${PYTHONVER}.msi ]; then
            wget https://www.python.org/ftp/python/${PYTHONVER}/python-${PYTHONVER}.amd64.msi -O python-${PYTHONVER}.msi
        fi

        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe -O vcredist.exe
        fi
        if [ ! -f pynacl.zip ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win-amd64.egg.zip -O pynacl_win64.zip && unzip -o pynacl_win64.zip && rm pynacl_win64.zip
        fi

        cd ..

        makensis windows/ob64.nsi
        ;;

    osx*)

        echo 'Building OS X binary'
	mkdir -p temp-$OS
	branch=master
	if ! [ -d OpenBazaar-Server ]; then
		echo "Cloning OpenBazaar-Server"
		clone_command 
	else
        	cd OpenBazaar-Server
        	git pull
	        cd ..     
	fi    
	npm install electron-packager
	npm install electron-installer-dmg

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install

	echo 'Packaging Electron application'
        cd ../temp-$OS
	../node_modules/.bin/electron-packager ../OpenBazaar-Client OpenBazaar --protocol-name=OpenBazaar --protocol=ob --platform=darwin --arch=x64 --icon=osx/tent.icns --version=${ELECTRONVER} --overwrite
        ../node_modules/.bin/electron-installer-dmg ./temp-$OS/OpenBazaar-darwin-x64/OpenBazaar.app OpenBazaar --icon ./osx/tent.icns --out=./temp-$OS/OpenBazaar-darwin-x64/ --overwrite --background=./osx/finder_background.png --debug
        
#	# Set up build directories
#        cp -rf OpenBazaar-Client build/
#        mkdir OpenBazaar-Client/OpenBazaar-Server

#        # Build OpenBazaar-Server Binary
#        cd OpenBazaar-Server
#        virtualenv env
#        source env/bin/activate
#        pip install -r requirements.txt
#        pip install git+https://github.com/pyinstaller/pyinstaller.git
#        env/bin/pyinstaller -F -n openbazaard -i ../osx/tent.icns --osx-bundle-identifier=com.openbazaar.openbazaard openbazaard.mac.spec
#        cp dist/openbazaard ../OpenBazaar-Client/OpenBazaar-Server
#        cp ob.cfg ../OpenBazaar-Client/OpenBazaar-Server
#        cd ..

        ;;

    linux*)

        echo 'Building Linux binary'
	mkdir -p temp-$OS
	branch=master
	if ! [ -d OpenBazaar-Server ]; then
		echo "Cloning OpenBazaar-Server"
		clone_command 
	else
        	cd OpenBazaar-Server
        	git pull
	        cd ..     
	fi    
   
	npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install

	echo 'Packaging Electron application'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaar --platform=linux --arch=all --version=${ELECTRONVER} --overwrite

#        # Set up build directories
#        cp -rf OpenBazaar-Client build/
#        mkdir OpenBazaar-Client/OpenBazaar-Server

#        # Build OpenBazaar-Server Binary
#        cd OpenBazaar-Server
#        virtualenv2 env
#        source env/bin/activate
#        pip2 install -r requirements.txt
#        pip2 install git+https://github.com/pyinstaller/pyinstaller.git
#        env/bin/pyinstaller -F -n openbazaard openbazaard.py
#        cp dist/openbazaard ../OpenBazaar-Client/OpenBazaar-Server
#        cp ob.cfg ../OpenBazaar-Client/OpenBazaar-Server
#        cd ..

esac
