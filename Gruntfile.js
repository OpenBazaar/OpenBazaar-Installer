module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    'electron-installer-debian': {
      options: {
        productName: 'OpenBazaar',
        arch: 'amd64',
        version: '1.1.8',
        maintainer: 'OpenBazaar <project@openbazaar.org>',
        rename: function (dest, src) {
          return dest + '<%= name %><%= clientonly %>_<%= version %>_<%= arch %>.deb';
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
        ],
        priority: 'optional'
      },
      'app-with-asar': {
        src: 'temp-linux64/openbazaar-linux-x64/',
        dest: 'build-linux64/',
        rename: function (dest) {
          return path.join(dest, '<%= name %><%= clientonly %>_<%= arch %>.deb')
        }
      }
    },
	'create-windows-installer': {
      x32: {
        appDirectory: grunt.option('appdir'),
        outputDirectory: grunt.option('outdir'),
        name: 'OpenBazaar'+(grunt.option('clientonly') || ''),
        productName: 'OpenBazaar'+grunt.option('clientonly'),
		authors: 'OpenBazaar',
        owners: 'OpenBazaar',
        exe: 'OpenBazaar.exe',
        description: 'OpenBazaar',
        version: grunt.option('obversion') || '',
        title: 'OpenBazaar',
        iconUrl: 'https://openbazaar.org/downloads/icon.ico',
        setupIcon: 'windows/icon.ico',
        loadingGif: 'windows/loading.gif',
        noMsi: true
	  }
	}
  });

  grunt.loadNpmTasks('grunt-electron-installer-debian');
  grunt.loadNpmTasks('grunt-electron-installer');

  // Default task(s).
  grunt.registerTask('default', ['electron-installer-debian']);

};
