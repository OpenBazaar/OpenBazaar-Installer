var gulp = require('gulp');
var winInstaller = require('electron-windows-installer');

gulp.task('create-windows-installer', function(done) {
  winInstaller({
    appDirectory: './temp/OpenBazaar-win32-x64',
    outputDirectory: './temp',
    author: 'OpenBazaar',
    iconUrl: 'http://openbazaar.com/icon.ico'
  }).then(done).catch(done);
});