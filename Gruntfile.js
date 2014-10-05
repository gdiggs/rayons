module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      files: ["app/**/*.js"],
      options: {
        eqeqeq: true,
        undef: true,
        unused: true,
        globals: {
          '$': true,
          jQuery: true,
          console: true,
          module: true,
          document: true,
          window: true,
          Rayons: true,
          confirm: true,
          '_': true,
          Mustache: true,
          CalHeatMap: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');

  // Default task(s).
  grunt.registerTask('default', ['jshint']);

};

