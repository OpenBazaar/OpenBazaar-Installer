#
# A short note why this bootstraper is needed:
# setup.py must specify a python file to be inserted into openbazaar.exe
# Before starting node/openbazaar.py it is needs to be bootstraped properly.
# In a development environment all packages and dependent libraries will be
# easy accessible. However, in an installed environment we have to make sure
# that our exe file can locate its depedencies without problems.
#

import ctypes
import ctypes.util
import os
import sys


# Get the folder of the exe file.
EXE_FILE = sys.argv[0]
PATH = os.path.dirname(os.path.realpath(EXE_FILE))

# We need to add the folder of libeay32.dll and gpg.exe on the path.
# This is needed for some packages to be able to detect them and function properly.
# Modifying the PATH variable on the installed system is prone to errors
# One example is if a x64 version of libeay32.dll is in PATH *before*
# ours, OpenBazaar won't be able to load libeay32.dll and fail to run.
os.environ["PATH"] = ";".join((PATH, r"%s\gpg\gpg" % PATH, os.environ["PATH"]))

# Add the full path to the egg file containing pycountry.
# This needs to be done before importing node (which depends on pycountry)
sys.path.append(os.path.join(PATH, "pycountry-1.8-py2.7.egg"))

from node import openbazaar

def main():

    # Try to locate gpg.exe
    if not ctypes.util.find_library('gpg.exe'):
        message_box = ctypes.windll.user32.MessageBoxA
        message_box(
            None,
            'Gpg4win could not be detected.\n'
            'Please download and install gpg4win from http://gpg4win.org/ before continuing.',
            'Open Bazaar',
            0
        )

        return

    # Workaround to make it possible to double click on the exe file
    sys.argv.append('start')

    # Start OpenBazaar
    openbazaar.main()

if __name__ == '__main__':
    main()
