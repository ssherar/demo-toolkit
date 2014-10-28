module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile_server:
        options:
          bare: true
        expand: true
        flatten: true
        cwd: "./"
        src: ["./index.coffee"]
        dest: 'bin/'
        ext: ".js"
      compile_client:
        options:
          bare: true
        expand: true
        flatten: true 
        cwd: "./"
        src: ["src/*.coffee"]
        dest: "js/"
        ext: ".js"
    clean:
      js: ["bin/*.js", "js/*.js"]
    watch:
      coffee_server:
        files: ["index.coffee"]
        tasks: ["coffee:compile_server"]
      coffee_client:
        files: ["src/*.coffee"]
        tasks: ["coffee:compile_client"]
    supervisor:
      target:
        script: "bin/index.js"
        options:
          watch: ['bin']
    mochaTest:
      options:
        reporter: 'spec'
        compilers: ['coffee:coffee-script/register']
      src: ["test/**/*.coffee"]
    express:
      myServer:
        server: "./bin/index.js"
    concurrent:
      options:
        logConcurrentOutput: true
      autoreload: ['supervisor', 'watch']
         
  )

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-supervisor'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'default', ['concurrent:autoreload']
  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'travis', ['coffee', 'mochaTest']
  null
