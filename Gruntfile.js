module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    'electron-installer-debian': {
      options: {
        productName: 'OpenBazaar',
        arch: 'amd64',
        rename: function (dest, src) {
          return dest + '<%= name %>_<%= version %>-<%= revision %>_<%= arch %>.deb';
        },
        productDescription: 'Decentralized Peer to Peer Marketplace for Bitcoin',
        lintianOverrides: [
          'changelog-file-missing-in-native-package',
          'executable-not-elf-or-script',
          'extra-license-file'
        ],
        icon: 'OpenBazaar-Client/imgs/openbazaar-icon.png',
        categories: [
          'Utility'
        ]
      },
      'app-with-asar': {
        src: 'temp-linux64/openbazaar-linux-x64/',
        dest: 'build-linux64/',
        rename: function (dest) {
          return path.join(dest, '<%= name %>_<%= arch %>.deb')
        }
      }
    },
	'create-windows-installer': {
	  x64: {
		appDirectory: 'temp-win64/OpenBazaar-win32-x64',
		outputDirectory: 'build-win64',
        name: 'OpenBazaar',
        productName: 'OpenBazaar',
		authors: 'OpenBazaar',
        owners: 'OpenBazaar',
        exe: 'OpenBazaar.exe',
        description: 'OpenBazaar',
        version: grunt.option('version') || '',
        title: 'OpenBazaar',
        iconUrl: 'https://openbazaar.org/downloads/icon.ico',
        setupIcon: 'windows/icon.ico',
        loadingGif: 'windows/ebay.gif',
        noMsi: true
	  }
	}
  });

  grunt.loadNpmTasks('grunt-electron-installer-debian');
  grunt.loadNpmTasks('grunt-electron-installer');

  // Default task(s).
  grunt.registerTask('default', ['electron-installer-debian']);

};