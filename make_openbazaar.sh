#!/bin/sh

## Version 0.1.0
##
## Usage
## ./make_openbazaar.sh OS
##	
## OS supported:
## win32 win64 linux osx
##


ELECTRONVER=0.37.6
NODEJSVER=5.1.1
PYTHONVER=2.7.11
UPXVER=391

OS="${1}"

# Get Version
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')
echo "OpenBazaar Version: $PACKAGE_VERSION"

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

# Clean past builds in OpenBazaar-Server
rm -rf OpenBazaar-Server/dist/*

#command_exists grunt
command_exists npm
#command_exists wine

# Notes about windows: In windows we want to compile the application for both
# 32 bit and 64 bit versions even if the host operating system is 64 bit.
# To make it possible to run either 32 bit and 64 bit versions of python
# we need to install Python 2.7 32 bit, Python 2.7 64 bit and afterwards
# we need to install latest Python 3 in either 32 or 64 bits. This is needed
# becuase starting with Python 3.3 a launcher is installed that allows us
# to run any python version that is already installed
# by calling either `py.exe -2.7-x64 ` or `py.exe -2.7-32`

# Download OS specific installer files to package
case $OS in win32*)
        export OB_OS=win32
        command_exists py

        echo 'Building Server Binary...'
        cd OpenBazaar-Server
        py.exe -2.7-32 -m pip install virtualenv
		
		if [ -d env-$OS ]; then
            rm -rf env-$OS
        fi

        if [ -d dist ]; then
            rm -rf dist
        fi
		
		if [ -d build ]; then
            rm -rf build
        fi
		
        py.exe -2.7-32 -m virtualenv env-$OS
        . env-$OS/scripts/activate
        pip install pyinstaller==3.1.1
		pip install setuptools==19.2 --upgrade
        pip install https://openbazaar.org/downloads/miniupnpc-1.9-cp27-none-win32.whl
        pip install https://openbazaar.org/downloads/PyNaCl-0.3.0-cp27-none-win32.whl
        pip install setuptools==19.2
        pip install -r requirements.txt
        pyinstaller --clean
        pyinstaller --clean -i ../windows/icon.ico ../openbazaard.win32.spec --win-private-assemblies --noconfirm
        cp -rf dist/openbazaard/* ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server
        cd ..

        echo 'Installing Node modules'
        npm install electron-packager@6.0.2
        cd OpenBazaar-Client
        npm install

        echo 'Building Client Binary...'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client OpenBazaar --asar=true --protocol-name=OpenBazaar --version-string.ProductName=OpenBazaar --protocol=ob --platform=win32 --arch=ia32 --icon=../windows/icon.ico --version=${ELECTRONVER} --overwrite
        cd ..

        echo 'Copying server files into application folder(s)...'
        cp -rf build-$OS/OpenBazaar-Server temp-$OS/OpenBazaar-win32-ia32/resources/

        echo 'Copying gpg files into application folder...'
        mkdir temp-$OS/OpenBazaar-win32-ia32/resources/gpg/
        cd temp-$OS/OpenBazaar-win32-ia32/resources/gpg/
        mkdir pub
        cp '/c/Program files (x86)/gnu/GnuPG/pub/gpg.exe' pub
        cp '/c/Program files (x86)/gnu/GnuPG/gpg2.exe' .
        cp '/c/Program files (x86)/gnu/GnuPG/gpgconf.exe' .
        cp '/c/Program files (x86)/gnu/GnuPG/libadns-1.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libassuan-0.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libgcrypt-20.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libgpg-error-0.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libiconv-2.dll' .

        echo 'Building Installer...'

        npm install -g grunt
        npm install --save-dev grunt-electron-installer

        # Build full version
        grunt create-windows-installer --obversion=$PACKAGE_VERSION --appdir=temp-$OS/OpenBazaar-win32-ia32 --outdir=build-$OS

        # Build client-only version
        rm -rf build-$OS/OpenBazaar-Server
        grunt create-windows-installer --obversion=$PACKAGE_VERSION --clientonly=Client --appdir=temp-$OS/OpenBazaar-win32-ia32 --outdir=build-$OS

	cd ../../../../
        mv build-$OS/OpenBazaarSetup.exe build-$OS/OpenBazaar-${PACKAGE_VERSION}_Setup_i386.exe
	mv build-$OS/RELEASES build-$OS/RELEASES_WIN32
	mv "build-$OS/OpenBazaar-$PACKAGE_VERSION-full.nupkg" "build-$OS/OpenBazaar-$PACKAGE_VERSION-i386-full.nupkg"

        echo "Do not forget to sign the release before distributing..."
        echo "signtool sign /t http://timestamp.digicert.com /a [filename]"
        ;;

    win64*)
        export OB_OS=win64

        command_exists py

        echo 'Building Server Binary...'
        cd OpenBazaar-Server
		
		if [ -d env-$OS ]; then
            rm -rf env-$OS
        fi

        if [ -d dist ]; then
            rm -rf dist
        fi
		
		if [ -d build ]; then
            rm -rf build
        fi
		
        py.exe -2.7-x64 -m pip install virtualenv
      
		py.exe -2.7-x64 -m virtualenv env-$OS
        . env-$OS/scripts/activate
        pip install pyinstaller==3.1.1
		pip install setuptools==19.2 --upgrade
        pip install https://openbazaar.org/downloads/miniupnpc-1.9-cp27-none-win_amd64.whl
        pip install https://openbazaar.org/downloads/PyNaCl-0.3.0-cp27-none-win_amd64.whl
        
        pip install -r requirements.txt
		
        
		rm -rf dist build
        
        pyinstaller --clean -i ../windows/icon.ico ../openbazaard.win.spec --win-private-assemblies --noconfirm
        cp -rf dist/openbazaard/* ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server
        cd ..

        echo 'Installing Node modules'
        npm install electron-packager@6.0.2
        cd OpenBazaar-Client
        npm install

        echo 'Building Client Binary...'
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client OpenBazaar --asar=true --protocol-name=OpenBazaar --version-string.ProductName=OpenBazaar --protocol=ob --platform=win32 --arch=x64 --icon=../windows/icon.ico --version=${ELECTRONVER} --overwrite
        cd ..

        echo 'Copying server files into application folder(s)...'
        cp -rf build-$OS/OpenBazaar-Server temp-$OS/OpenBazaar-win32-x64/resources/

        echo 'Copying gpg files into application folder...'
        mkdir temp-$OS/OpenBazaar-win32-x64/resources/gpg/
        cd temp-$OS/OpenBazaar-win32-x64/resources/gpg/
        mkdir pub
        cp '/c/Program files (x86)/gnu/GnuPG/pub/gpg.exe' pub
        cp '/c/Program files (x86)/gnu/GnuPG/gpg2.exe' .
        cp '/c/Program files (x86)/gnu/GnuPG/gpgconf.exe' .
        cp '/c/Program files (x86)/gnu/GnuPG/libadns-1.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libassuan-0.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libgcrypt-20.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libgpg-error-0.dll' .
        cp '/c/Program files (x86)/gnu/GnuPG/libiconv-2.dll' .

        echo 'Building Installer...'

        npm install -g grunt
        npm install --save-dev grunt-electron-installer

        grunt create-windows-installer --obversion=$PACKAGE_VERSION --appdir=temp-$OS/OpenBazaar-win32-x64 --outdir=build-$OS

	cd ../../../../
	mv build-$OS/OpenBazaarSetup.exe "build-$OS/OpenBazaar-${PACKAGE_VERSION}_Setup_x64.exe"
	
        echo "Do not forget to sign the release before distributing..."
        echo "signtool sign /t http://timestamp.digicert.com /a [filename]"
        ;;

    osx*)

        echo 'Building OS X binary...'

        echo 'Cleaning build directories...'
        if [ -d build-$OS ]; then
            rm -rf build-$OS/*
        fi

        if [ -d temp-$OS ]; then
            rm -rf temp-$OS/*
        fi

        echo 'Installing node.js packages for installer...'
        npm install electron-packager
        npm install electron-installer-dmg

        echo 'Installing node.js packages for OpenBazaar-Client...'
        cd OpenBazaar-Client
        npm install
        cd ..

        echo 'Creating virtualenv and building OpenBazaar-Server binary...'
        cd OpenBazaar-Server
        virtualenv env
        . env/bin/activate
        pip install --upgrade pip
        pip install --ignore-installed -r requirements.txt
        pip install --ignore-installed pyinstaller==3.1
        pip install setuptools==19.1
        env/bin/pyinstaller -F -n openbazaard -i ../osx/tent.icns --osx-bundle-identifier=com.openbazaar.openbazaard ../openbazaard.mac.spec
        echo 'Completed building OpenBazaar-Server binary...'

        echo 'Code-signing Daemon binaries...'
        codesign --force --sign "$SIGNING_IDENTITY" dist/openbazaard
        codesign --force --sign "$SIGNING_IDENTITY" ob.cfg
        cd ..

        echo 'Packaging Electron application...'
        cd temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client OpenBazaar --app-category-type=public.app-category.business --protocol-name=OpenBazaar --protocol=ob --platform=darwin --arch=x64 --icon=../osx/tent.icns --version=${ELECTRONVER} --overwrite --app-version=$PACKAGE_VERSION
        cd ..

        echo 'Moving .app to build directory...'
        mv temp-$OS/OpenBazaar-darwin-x64/* build-$OS/
        rm -rf build-$OS/OpenBazaar-darwin-x64

        echo 'Create OpenBazaar-Server folder inside the .app...'
        mkdir build-$OS/OpenBazaar.app/Contents/Resources/OpenBazaar-Server

        cd OpenBazaar-Server
        echo 'Copy binary files to .app folder...'
        cp dist/openbazaard ../build-$OS/OpenBazaar.app/Contents/Resources/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar.app/Contents/Resources/OpenBazaar-Server
        cd ..

        echo 'Creating DMG installer from build...'
        npm i electron-installer-dmg -g
        codesign --force --deep --sign "$SIGNING_IDENTITY" ./build-$OS/OpenBazaar.app
        electron-installer-dmg ./build-$OS/OpenBazaar.app OpenBazaar-$PACKAGE_VERSION --icon ./osx/tent.icns --out=./build-$OS --overwrite --background=./osx/finder_background.png --debug

        echo 'Codesign the DMG and zip'
        codesign --force --sign "$SIGNING_IDENTITY" ./build-$OS/OpenBazaar-$PACKAGE_VERSION.dmg
        cd build-$OS
        zip -r OpenBazaar-mac-$PACKAGE_VERSION.zip OpenBazaar.app

        ;;

    linux32*)

        echo "Building Linux binary (ia32)"

        echo "Clean/empty build-$OS"
        if [ -d build-$OS ]; then
            rm -rf build-$OS/*
        else
            mkdir build-$OS
        fi

        echo "Create clean temp-$OS folder if necessary"
        if ! [ -d temp-$OS ]; then
            mkdir -p temp-$OS
        else
            rm -rf temp-$OS/*
        fi

        echo "Pull code from GitHub"
        branch=master
        if ! [ -d OpenBazaar-Server ]; then
            echo "Cloning OpenBazaar-Server"
            clone_command
        else
            cd OpenBazaar-Server
            git pull
            cd ..
        fi

        echo "Installing npm packages for installer"
        sudo apt-get install npm python-pip python-virtualenv python-dev libffi-dev
        npm install electron-packager@6.0.2

        echo "Installing npm packages for the Client"
        cd OpenBazaar-Client
        npm install
        cd ..

        # Build OpenBazaar-Server Binary
        echo "Building OpenBazaar-Server binary"

        mkdir build-$OS/OpenBazaar-Server
        cd OpenBazaar-Server
        virtualenv env
        . env/bin/activate
        pip install -r requirements.txt
        pip install pyinstaller==3.1
        pip install cryptography
        pyinstaller -D -F -n openbazaard ../openbazaard.linux.spec

        echo "Copy openbazaard to build folder"
        cp dist/openbazaard ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server

	    echo "Packaging Electron application"
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaar --platform=linux --arch=all --version=${ELECTRONVER} --overwrite --prune

        cd ..

        cp -rf build-$OS/OpenBazaar-Server temp-$OS/openbazaar-linux-ia32/resources

	    sudo npm install -g electron-packager@6.0.2
	    #npm install -g grunt-cli
        #npm install -g grunt-electron-installer --save-dev
        #npm install -g grunt-electron-installer-debian --save-dev
        sudo npm install -g electron-installer-debian@0.1.1

        electron-installer-debian --config linux/config_ia32.json

	# Client only install
        cd temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaarclient --platform=linux --arch=all --version=${ELECTRONVER} --overwrite --prune
	cd ..
        rm -rf build-$OS/OpenBazaar-Server temp-$OS/openbazaarclient-linux-ia32/resources/OpenBazaar-Server
	electron-installer-debian --clientonly=Client --config linux/config_ia32.client.json

	    echo "Build done in build-$OS"
	;;
    linux64*)

        echo "Building Linux binary (x64)"

        echo "Clean/empty build-$OS"
        if [ -d build-$OS ]; then
            rm -rf build-$OS/*
        else
            mkdir build-$OS
        fi

        echo "Create clean temp-$OS folder if necessary"
        if ! [ -d temp-$OS ]; then
            mkdir -p temp-$OS
        else
            rm -rf temp-$OS/*
        fi

        echo "Pull code from GitHub"
        branch=master
        if ! [ -d OpenBazaar-Server ]; then
            echo "Cloning OpenBazaar-Server"
            clone_command
        else
            cd OpenBazaar-Server
            git pull
            cd ..
        fi

        echo "Installing npm packages for installer"
        sudo apt-get install npm python-pip python-virtualenv python-dev libffi-dev
        npm install electron-packager@6.0.2

        echo "Installing npm packages for the Client"
        cd OpenBazaar-Client
        npm install
        cd ..

        # Build OpenBazaar-Server Binary
        echo "Building OpenBazaar-Server binary"

        mkdir build-$OS/OpenBazaar-Server
        cd OpenBazaar-Server
        virtualenv env
        . env/bin/activate
        pip install -r requirements.txt
        pip install pyinstaller==3.1
        pip install cryptography
        pyinstaller -D -F -n openbazaard ../openbazaard.linux.spec

        echo "Copy openbazaard to build folder"
        cp dist/openbazaard ../build-$OS/OpenBazaar-Server
        cp ob.cfg ../build-$OS/OpenBazaar-Server

	echo "Packaging Electron application"
        cd ../temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaar --platform=linux --arch=all --version=${ELECTRONVER} --overwrite --prune
        cd ..

	# Copy server daemon and cfg into resources folder
        cp -rf build-$OS/OpenBazaar-Server temp-$OS/openbazaar-linux-x64/resources

	sudo npm install -g electron-packager@6.0.2
        sudo npm install -g electron-installer-debian@0.1.1

        electron-installer-debian --config linux/config_amd64.json

	# Client only install
        cd temp-$OS
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client openbazaarclient --platform=linux --arch=all --version=${ELECTRONVER} --overwrite --prune
	cd ..
        rm -rf build-$OS/OpenBazaar-Server temp-$OS/openbazaarclient-linux-x64/resources/OpenBazaar-Server
	electron-installer-debian --clientonly=Client --config linux/config_amd64.client.json


	echo "Build done in build-$OS"

esac

