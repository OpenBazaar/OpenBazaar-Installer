module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    'electron-debian-installer': {

      options: {
        productName: 'OpenBazaar',
        rename: function (dest, src) {
          return dest + '<%= name %>_<%= version %>-<%= revision %>_<%= arch %>.deb';
        }
      },
      linux32: {
        options: {
          arch: 'i386'
        },
        src: 'temp/OpenBazaar-linux-ia32/',
        dest: 'temp/'
      },
      linux64: {
        options: {
          arch: 'amd64'
        },
        src: 'temp/OpenBazaar-linux-x64/',
        dest: 'temp/'
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

  grunt.loadNpmTasks('grunt-electron-debian-installer');
  grunt.loadNpmTasks('grunt-electron-installer');

  // Default task(s).
  grunt.registerTask('default', ['electron-debian-installer']);

};