#!/bin/sh

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

branch=master
if ! [ -d OpenBazaar-Server ]; then
    echo "Cloning OpenBazaar-Server"
    clone_command 
else
    cd OpenBazaar-Server
    git pull
    cd ..
fi

if [ -z "${dir}" ]; then
    dir="."
fi
cd ${dir}
echo "Switched to ${PWD}"

if [ -d build-$OS ]; then
    rm -rf build-$OS
fi

mkdir -p temp-$OS
mkdir -p build-$OS/OpenBazaar-Server

command_exists grunt
command_exists npm
command_exists wine

# Download OS specific installer files to package
case $OS in win32*)
    export OB_OS=win32



        ;;
    win64*)
        export OB_OS=win64

	branch=noupnp
	if ! [ -d OpenBazaar-Server ]; then
		echo "Cloning OpenBazaar-Server"
		clone_command
	else
        	cd OpenBazaar-Server
        	git pull
	        cd ..     
	fi    

        rm -rf build/*

        echo 'Copying OpenBazaar-Client to build dir...'
        cp -rf OpenBazaar-Client build/

        echo 'Building Server Binary...'
        cd OpenBazaar-Server
        pip install virtualenv
        virtualenv env
        env/Scripts/activate.bat
        pip install -r requirements.txt
        pip install pyinstaller==3.0
        pip install ../windows/PyNaCl-0.3.0-py2.70-win32.egg
        pyinstaller -i ../windows/icon.ico openbazaard.py
        cp dist/openbazaard/* ../build/OpenBazaar-Server
        cp ob.cfg ../build/OpenBazaar-Server
        cd ..

        npm install electron-packager electron-builder
        node_modules/.bin/electron-packager ./build/OpenBazaar-Client OpenBazaar --asar=true --protocol-name=OpenBazaar --protocol=ob --platform=win32 --arch=all --icon=windows/icon.ico --version=0.36.1 --out=temp/ --overwrite

        echo 'Copying server files into application folder(s)...'
        cp -rf build/OpenBazaar-Server temp/OpenBazaar-win32-x64/resources/
        cp -rf build/OpenBazaar-Server temp/OpenBazaar-win32-ia32/resources/

        # Build x64
        node_modules/.bin/electron-builder temp/OpenBazaar-win32-x64/ --platform=win --out=temp/OpenBazaar_Setup_x64.exe --config=config.json
        #cp "OpenBazaar Setup.exe" "OpenBazaar_Setup_x64.exe"

        # Build ia32
        node_modules/.bin/electron-builder temp/OpenBazaar-win32-ia32/ --platform=win --out=temp/OpenBazaar_Setup_ia32.exe --config=config.json
        #cp "OpenBazaar Setup.exe" "OpenBazaar_Setup_ia32.exe"

        ;;

    osx*)

        echo 'Building OS X binary'

	npm install electron-packager
	npm install electron-installer-dmg

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install

	echo 'Packaging Electron application'
        cd ../temp-$OS
	../node_modules/.bin/electron-packager ../OpenBazaar-Client OpenBazaar --protocol-name=OpenBazaar --protocol=ob --platform=darwin --arch=x64 --icon=osx/tent.icns --version=${ELECTRONVER} --overwrite
#        ../node_modules/.bin/electron-installer-dmg ../OpenBazaar-darwin-x64/OpenBazaar.app OpenBazaar --icon ../osx/tent.icns --out=../OpenBazaar-darwin-x64/ --overwrite --background=../osx/finder_background.png --debug

        cd .. 
	echo 'Rename the folder'
        mv temp-$OS/OpenBazaar_Client-darwin-x64 build-$OS/
	rm -rf build-$OS//OpenBazaar_Client-darwin-x64   

        # Build OpenBazaar-Server Binary
        cd OpenBazaar-Server
        virtualenv env
        source env/bin/activate
        pip install -r requirements.txt
        pip install git+https://github.com/pyinstaller/pyinstaller.git
        env/bin/pyinstaller -F -n openbazaard -i ../osx/tent.icns --osx-bundle-identifier=com.openbazaar.openbazaard openbazaard.mac.spec
        cp dist/openbazaard ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server

        ;;

    linux32*)

        echo 'Building Linux binary'
   
	npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install

	echo 'Packaging Electron application'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaar --platform=linux32 --arch=all --version=${ELECTRONVER} --overwrite

         cd ..
        # Set up build directories
        cp -rf OpenBazaar-Client build-$OS

        # Build OpenBazaar-Server Binary
        cd OpenBazaar-Server
        virtualenv2 env
        source env/bin/activate
        pip2 install -r requirements.txt
        pip2 install git+https://github.com/pyinstaller/pyinstaller.git
        env/bin/pyinstaller -F -n openbazaard openbazaard.py
        cp dist/openbazaard ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server
	echo "Build done in build-$OS"
	;;
    linux64*)

        echo 'Building Linux binary'
   
	npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install

	echo 'Packaging Electron application'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaar --platform=linux64 --arch=all --version=${ELECTRONVER} --overwrite

         cd ..
        # Set up build directories
        cp -rf OpenBazaar-Client build-$OS

        # Build OpenBazaar-Server Binary
        cd OpenBazaar-Server
        virtualenv2 env
        source env/bin/activate
        pip2 install -r requirements.txt
        pip2 install git+https://github.com/pyinstaller/pyinstaller.git
        env/bin/pyinstaller -F -n openbazaard openbazaard.py
        cp dist/openbazaard ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server
	echo "Build done in build-$OS"

esac
