#global module:false
module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-env'

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    env:
      options: {}
      build:
        NODE_ENV: 'production'

    coffee:
      addon:
        expand: true
        cwd: 'src/js/',
        src: ['**/*.coffee']
        dest: 'build/js/'
        ext: '.js'
        options:
          bare: true

    copy:
      addon:
        expand: true
        cwd: 'src/'
        src: ['**/*.js']
        dest: 'build'

    browserify:
      addon:
        cwd: "build/js/"
        src: ["addon.js"]
        dest: "build/addon.js"
        options:
          alias: ["./build/js/addon.js:addon"]

          # wrapp as Taist addon
          postBundleCB: (err, src, next) ->
            src = "function init(){var " + src + ";return require(\"addon\")}"
            next err, src
            return

    concat:
      addon:
        src: [
          "build/addon.js"
          "src/lib/sample.js"
        ]
        dest: "dist/addon.js"

    watch:
      files: ['src/js/**/*.js', 'src/js/**/*.coffee']
      tasks: ['build']

  grunt.registerTask "default", [
    "devbuild"
    "watch"
  ]

  grunt.registerTask "devbuild", [
    "coffee:addon"
    "copy:addon"
    "browserify:addon"
    "concat:addon"
  ]

  grunt.registerTask "build", [
    "env:build"
    "coffee:addon"
    "copy:addon"
    "browserify:addon"
    "concat:addon"
  ]

  return
