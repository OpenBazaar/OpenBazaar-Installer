#!/bin/bash

## Version 0.1.0
##
## Usage
## ./make_openbazaar.sh [url]
##
## The script make_openbazaar.sh allows you to clone, setup, and build a version of OpenBazaar
## The [url] handle is optional and allows you to pick what repository you wish to clone
## If you use 'ssh' in the place of the optional [url] parameter, it will clone via ssh instead of http
##
## Optionally, you can also pass in a specific branch to build or clone, by making url contain a branch specifier
## ./make_openbazaar.sh '-b release/0.3.4 https://github.com/OpenBazaar/OpenBazaar.git'
##
ELECTRONVER=0.36.2
NODEJSVER=5.3.0
PYTHONVER=2.7.11
UPXVER=391

OS="${1}"

# Check if user specified repository to pull code from
clone_repo="True"
clone_url_server="https://github.com/OpenBazaar/OpenBazaar-Server.git"
clone_url_client="https://github.com/OpenBazaar/OpenBazaar-Client.git"

command_exists () {
    if ! [ -x "$(command -v $1)" ]; then
 	echo "$1 is not installed." >&2
    fi
}

clone_command() {
    if git clone ${clone_url_server} ${dir}; then
        echo "Cloned OpenBazaar Server successfully"
    else
        echo "OpenBazaar encountered an error and could not be cloned"
        exit 2
    fi
}

clone_command_client() {
    if git clone ${clone_url_client} ${dir}; then
        echo "Cloned OpenBazaar Client successfully"
    else
        echo "OpenBazaar encountered an error and could not be cloned"
        exit 2
    fi
}

if ! [ -d OpenBazaar-Server ]; then
	echo "Cloning OpenBazaar-Server"
	clone_command
fi    

if ! [ -d OpenBazaar-Client ]; then
	echo "Cloning OpenBazaar-Client"
	clone_command_client
fi     

if [ -z "${dir}" ]; then
    dir="."
fi
cd ${dir}
echo "Switched to ${PWD}"

# Check for temp folder and create if does not exist
mkdir -p temp

command_exists grunt
command_exists npm
command_exists wine

# Download OS specific installer files to package
case $OS in win32*)
        export OB_OS=win32
	
        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
        npm install flatten-packages
        node_modules/.bin/flatten-packages

        echo 'Packaging Electron application'
        cd ../temp
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=ia32 --version=${ELECTRONVER} --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp/OpenBazaar_Client-win32-ia32 temp/OpenBazaar-Client

        echo 'Downloading installers'

        cd temp
	
	if [ ! -f upx${UPXVER}w.zip ]; then
            wget http://upx.sourceforge.net/download/upx${UPXVER}w.zip -O upx.zip
	    unzip -o -j upx.zip
        fi

#        if [ ! -f electron.zip ]; then
#            wget https://github.com/atom/electron/releases/download/v${ELECTRONVER}/electron-v${ELECTRONVER}-win32-ia32.zip -O electron.zip 
&& unzip -o #electron.zip -d electron && rm electron.zip
#        fi

        if [ ! -f python-${PYTHONVER}.msi ]; then
            wget https://www.python.org/ftp/python/${PYTHONVER}/python-${PYTHONVER}.msi -O python-${PYTHONVER}.msi
        fi

	if [ ! -f node.msi ]; then
            wget https://nodejs.org/download/release/v${NODEJSVER}/node-v${NODEJSVER}-x86.msi -O node.msi
        fi

        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe -O vcredist.exe
        fi

        if [ ! -f pynacl ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win32.egg.zip -O pynacl_win32.zip && unzip -o pynacl_win32.zip && rm 
pynacl_win32.zip
        fi

        cd ..

        makensis windows/ob.nsi
        ;;
    win64*)
        export OB_OS=win64

        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
        npm install flatten-packages
        node_modules/.bin/flatten-packages

        echo 'Packaging Electron application'
        cd ../temp
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=x64 --version=${ELECTRONVER} --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp/OpenBazaar_Client-win32-x64 temp/OpenBazaar-Client

        echo 'Downloading installers'
        cd temp/
	
	if [ ! -f upx${UPXVER}w.zip ]; then
            wget http://upx.sourceforge.net/download/upx${UPXVER}w.zip -O upx.zip
	    unzip -o -j upx.zip
        fi

        if [ ! -f python-${PYTHONVER}.msi ]; then
            wget https://www.python.org/ftp/python/${PYTHONVER}/python-${PYTHONVER}.amd64.msi -O python-${PYTHONVER}.msi
        fi
        
	if [ ! -f node.msi ]; then
            wget https://nodejs.org/download/release/v${NODEJSVER}/node-v${NODEJSVER}-x64.msi -O node.msi
        fi
#        if [ ! -f electron.zip ]; then
#            wget https://github.com/atom/electron/releases/download/v${ELECTRONVER}/electron-v${ELECTRONVER}-win32-x64.zip -O electron.zip 
&& unzip -o electron.zip -d electron && rm electron.zip
#        fi
#        if [ ! -f pywin32.exe ]; then
#            wget http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win-amd64-py2.7.exe/download -O pywin32.exe
#        fi
        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe -O vcredist.exe
        fi
        if [ ! -f pynacl.zip ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win-amd64.egg.zip -O pynacl_win64.zip && unzip -o pynacl_win64.zip && rm 
pynacl_win64.zip
        fi

        cd ..

        makensis windows/ob64.nsi
        ;;

    osx*)
        echo 'Building OS X binary'

        # Set up build directories
        cp -rf OpenBazaar-Client build/
        mkdir OpenBazaar-Client/OpenBazaar-Server

        # Build OpenBazaar-Server Binary
        cd OpenBazaar-Server
        virtualenv env
        source env/bin/activate
        pip install -r requirements.txt
        pip install git+https://github.com/pyinstaller/pyinstaller.git
        env/bin/pyinstaller -F -n openbazaard -i ../osx/tent.icns --osx-bundle-identifier=com.openbazaar.openbazaard openbazaard.mac.spec
        cp dist/openbazaard ../OpenBazaar-Client/OpenBazaar-Server
        cp ob.cfg ../OpenBazaar-Client/OpenBazaar-Server
        cd ..

        # Build Client
        electron-packager ./build/OpenBazaar-Client OpenBazaar --protocol-name=OpenBazaar --protocol=ob --platform=darwin --arch=x64 --icon=osx/tent.icns --version=${ELECTRONVER} --out=temp/ --overwrite
        npm i electron-installer-dmg -g
        electron-installer-dmg ./temp/OpenBazaar-darwin-x64/OpenBazaar.app OpenBazaar --icon ./osx/tent.icns --out=./temp/OpenBazaar-darwin-x64/ --overwrite --background=./osx/finder_background.png --debug
        ;;

    linux*)

        echo 'Building Linux binary'

        # Set up build directories
        cp -rf OpenBazaar-Client build/
        mkdir OpenBazaar-Client/OpenBazaar-Server

        # Build OpenBazaar-Server Binary
        cd OpenBazaar-Server
        virtualenv2 env
        source env/bin/activate
        pip2 install -r requirements.txt
        pip2 install git+https://github.com/pyinstaller/pyinstaller.git
        env/bin/pyinstaller -F -n openbazaard openbazaard.py
        cp dist/openbazaard ../OpenBazaar-Client/OpenBazaar-Server
        cp ob.cfg ../OpenBazaar-Client/OpenBazaar-Server
        cd ..


	    npm install electron-packager
	    npm install grunt-cli
            npm install grunt-electron-debian-installer --save-dev

	    cd OpenBazaar-Client/
	    npm install
	    cd ..

        electron-packager ./build/OpenBazaar-Client openbazaar --platform=linux --arch=all --version=${ELECTRONVER} --out=temp/ --overwrite

        # Package into debian format
        grunt
esac
