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

if [ -e ".git/config" ]; then
    dat=`cat .git/config | grep 'url'`
    case ${dat} in *OpenBazaar-6*)
        echo "You appear to be inside of a OpenBazaar repository already, not cloning"
        clone_repo="False"
        ;;
    *)
        try="True"
        tries=0
        while [ "${try}" = "True" ]; do
            read -p "Looks like we are inside a git repository, do you wish to clone inside it? (yes/no) [no] " rd_cln
            if [ -z "${rd_cln}" ]; then
                rd_cln='no'
            fi
            tries=$((${tries}+1))
            if [ "${rd_cln}" = "yes" ] || [ "${rd_cln}" = "no" ]; then
                try="False"
            elif [ "$tries" -ge "3" ]; then
                echo "No valid input, exiting"
                exit 1
            else
                echo "Not a valid answer, please try again"
            fi
        done
        if [ "$rd_cln" = "no" ]; then
            echo "You appear to be inside of a OpenBazaar repository already, not cloning"
            clone_repo="False"
        else
            echo "You've chosen to clone inside the current directory"
        fi
        ;;
    esac
fi
if [ "${clone_repo}" = "True" ]; then
    echo "Cloning OpenBazaar-Server"
    read -p "Where do you wish to clone OpenBazaar-Server to? [OpenBazaar-Server] " dir
    if [ -z "${dir}" ]; then
        dir='OpenBazaar-Server'
    elif [ "${dir}" = "/" ]; then
        dir='OpenBazaar-Server'
    fi
    if [ ! -d "${dir}" ]; then
        clone_command
    else
        try="True"
        tries=0
        while [ "$try" = "True" ]; do
            read -p "Directory ${dir} already exists, do you wish to delete it and redownload? (yes/no) [no] " rd_ans
            if [ -z "${rd_ans}" ]; then
                rd_ans='no'
            fi
            tries=$((${tries}+1))
            if [ "${rd_ans}" = "yes" ] || [ "${rd_ans}" = "no" ]; then
                try="False"
            elif [ "$tries" -ge "3" ]; then
                echo "No valid input, exiting"
                exit 3
            else
                echo "Not a valid answer, please try again"
            fi
        done
        if [ "${rd_ans}" = "yes" ]; then
            echo "Removing old directory"
            if [ "${dir}" != "." ] || [ "${dir}" != "$PWD" ]; then
                echo "Cleaning up from inside the destination directory"
                rm -rf ${dir}/*
            else
                echo "Cleaning up from outside the destination directory"
                rm -rf ${dir}
            fi
            clone_command
        else
            echo "Directory already exists and you've chosen not to clone again"
        fi
    fi

    echo "Cloning OpenBazaar-Client"
    read -p "Where do you wish to clone OpenBazaar-Client to? [OpenBazaar-Client] " dir
    if [ -z "${dir}" ]; then
        dir='OpenBazaar-Client'
    elif [ "${dir}" = "/" ]; then
        dir='OpenBazaar-Client'
    fi
    if [ ! -d "${dir}" ]; then
        clone_command_client
    else
        try="True"
        tries=0
        while [ "$try" = "True" ]; do
            read -p "Directory ${dir} already exists, do you wish to delete it and redownload? (yes/no) [no] " rd_ans
            if [ -z "${rd_ans}" ]; then
                rd_ans='no'
            fi
            tries=$((${tries}+1))
            if [ "${rd_ans}" = "yes" ] || [ "${rd_ans}" = "no" ]; then
                try="False"
            elif [ "$tries" -ge "3" ]; then
                echo "No valid input, exiting"
                exit 3
            else
                echo "Not a valid answer, please try again"
            fi
        done
        if [ "${rd_ans}" = "yes" ]; then
            echo "Removing old directory"
            if [ "${dir}" != "." ] || [ "${dir}" != "$PWD" ]; then
                echo "Cleaning up from inside the destination directory"
                sudo rm -rf ${dir}/*
            else
                echo "Cleaning up from outside the destination directory"
                sudo rm -rf ${dir}
            fi
            clone_command
        else
            echo "Directory already exists and you've chosen not to clone again"
        fi
    fi
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
	npm install grunt-cli
        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
        npm install flatten-packages
        node_modules/.bin/flatten-packages

        echo 'Packaging Electron application'
        cd ../temp
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=ia32 --version=0.33.9 --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp/OpenBazaar_Client-win32-ia32 temp/OpenBazaar-Client

        echo 'Downloading installers'

        cd temp
	
	if [ ! -f node.msi ]; then
            wget https://nodejs.org/download/release/v4.1.2/node-v4.1.2-x86.msi -O node.msi
        fi

        if [ ! -f python-2.7.11.msi ]; then
            wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi -O python-2.7.11.msi
        fi

        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe -O vcredist.exe
        fi

        if [ ! -f pynacl ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win32.egg.zip -O pynacl_win32.zip && unzip pynacl_win32.zip && rm pynacl_win32.zip
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win-amd64.egg.zip -O pynacl_win64.zip && unzip pynacl_win64.zip && rm pynacl_win64.zip
        fi

        cd ..

        makensis windows/ob.nsi
        ;;
    win64*)
        export OB_OS=win64

       	npm install grunt-cli
        npm install electron-packager

        echo 'Compiling node packages'
        cd OpenBazaar-Client
        npm install
        npm install flatten-packages
        node_modules/.bin/flatten-packages

        echo 'Packaging Electron application'
        cd ../temp
        ../node_modules/.bin/electron-packager ../OpenBazaar-Client/ OpenBazaar_Client --platform=win32 --arch=x64 --version=0.33.9 --asar --icon=../windows/icon.ico --overwrite
        cd ..

        echo 'Rename the folder'
        mv temp/OpenBazaar_Client-win32-x64 temp/OpenBazaar-Client

        echo 'Downloading installers'
        cd temp/

        if [ ! -f python-2.7.10.msi ]; then
            wget https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi -O python-2.7.10.msi
        fi
        if [ ! -f node.msi ]; then
            wget https://nodejs.org/download/release/v4.1.2/node-v4.1.2-x64.msi -O node.msi
        fi
#        if [ ! -f electron.zip ]; then
#            wget https://github.com/atom/electron/releases/download/v0.33.1/electron-v0.33.1-win32-x64.zip -O electron.zip && unzip electron.zip -d electron && rm electron.zip
#        fi
#        if [ ! -f pywin32.exe ]; then
#            wget http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win-amd64-py2.7.exe/download -O pywin32.exe
#        fi
        if [ ! -f vcredist.exe ]; then
            wget http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe -O vcredist.exe
        fi
        if [ ! -f pynacl.zip ]; then
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win32.egg.zip -O pynacl_win32.zip && unzip pynacl_win32.zip && rm pynacl_win32.zip
            wget https://openbazaar.org/downloads/PyNaCl-0.3.0-py2.7-win-amd64.egg.zip -O pynacl_win64.zip && unzip pynacl_win64.zip && rm pynacl_win64.zip
        fi

        cd ..

        makensis ./windows/ob.nsi
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
        electron-packager ./build/OpenBazaar-Client OpenBazaar --protocol-name=OpenBazaar --protocol=ob --platform=darwin --arch=x64 --icon=osx/tent.icns --version=0.36.1 --out=temp/ --overwrite
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
        env/bin/pyinstaller -F -n openbazaard -i ../linux/icons/128x128.png openbazaard.py
        cp dist/openbazaard ../OpenBazaar-Client/OpenBazaar-Server
        cp ob.cfg ../OpenBazaar-Client/OpenBazaar-Server
        cd ..


	    npm install electron-packager
	    npm install grunt-cli
            npm install grunt-electron-debian-installer --save-dev

	    cd OpenBazaar-Client/
	    npm install
	    cd ..

        electron-packager ./build/OpenBazaar-Client openbazaar --platform=linux --arch=all --version=0.36.1 --out=temp/ --overwrite

        # Package into debian format
        grunt



esac
