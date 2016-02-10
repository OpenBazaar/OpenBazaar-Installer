# -*- mode: python -*-
a = Analysis(['OpenBazaar-Server/openbazaard.py'],
             pathex=['/Users/brianhoffman/Projects/OpenBazaar-Installer'],
             hiddenimports=[],
             hookspath=None,
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='openbazaard',
          debug=True,
          strip=None,
          upx=True,
          console=True )
app = BUNDLE(exe,
             name='openbazaard.app',
             icon=None)
