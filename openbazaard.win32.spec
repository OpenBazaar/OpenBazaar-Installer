# -*- mode: python -*-

block_cipher = None


a = Analysis(['OpenBazaar-Server\\openbazaard.py'],
             pathex=['OpenBazaar-Server'],
             binaries=None,
             datas=None,
             hiddenimports=['cryptography', 'bitcoin'],
             hookspath=None,
             runtime_hooks=None,
             excludes=None,
             win_no_prefer_redirects=None,
             win_private_assemblies=None,
             cipher=block_cipher)
a.binaries += [('ssleay32.dll', '..\\windows\\ssleay32.dll', 'BINARY'),
('libeay32.dll', '..\\windows\\libeay32.dll', 'BINARY')]
a.datas += [
('ob.cfg', 'ob.cfg', 'DATA'),
('bitcointools\\english.txt', '..\\windows\\english.txt', 'DATA')
]
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=True,
          name='openbazaard',
          icon='..\\windows\\icon.ico',
          debug=False,
          strip=None,
          upx=True,
          console=True )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=None,
               upx=True,
               name='openbazaard')
