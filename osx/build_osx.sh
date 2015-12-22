#!/bin/sh

case ${OSTYPE} in *darwin*)
    # if this fails please run `brew install coreutils` - homebrew also has this package
    alias readlink=greadlink
    ;;
esac

dir="$(dirname $(readlink -f ${0}))"
build="builds"
app="${build}/OpenBazaar.app"
identity="2Z88DW977Y"

if [ -z "$1" ]; then
  echo "You need to provide the version."
  exit 1
fi

echo "### remove previous dmg"
rm -rf ${build}/*.dmg

echo "### signing frameworks"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/Frameworks/nwjs Framework.framework/nwjs Framework"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/Frameworks/nwjs Helper EH.app/"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/Frameworks/nwjs Helper NP.app/"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/Frameworks/nwjs Helper.app/"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/Frameworks/crash_inspector"

echo "### signing webkit"
#codesign --force --verify --verbose --sign "${identity}" "${app}/Contents/MacOS/nwjs"

echo "### signing app"
#codesign --force --verify --verbose --sign "${identity}" "${app}"

echo "### verifying signature"
#codesign -vvv -d "${app}"

echo "### create dmg"
./create-dmg/create-dmg --volname "OpenBazaar ${1}" --window-size 480 540 --icon-size 128 --app-drop-link 240 370 --icon "OpenBazaar" 240 110 "${build}/OpenBazaar-${1}-Mac.dmg" "${build}"

dmg="${build}/OpenBazaar-${1}-Mac.dmg"

echo "### signing dmg"
#codesign --force --verify --verbose --sign "${identity}" "${dmg}"

echo "### verifying signature"
#codesign -vvv -d "${dmg}"