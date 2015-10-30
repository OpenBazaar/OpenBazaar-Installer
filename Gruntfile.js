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

    }
  });

  grunt.loadNpmTasks('grunt-electron-debian-installer');

  // Default task(s).
  grunt.registerTask('default', ['electron-debian-installer']);

};