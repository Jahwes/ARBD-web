gulp       = require 'gulp'
del        = require 'del'
cssmin     = require 'gulp-cssmin'
gutil      = require 'gulp-util'
ngAnnotate = require 'gulp-ng-annotate'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
ngHtml2Js  = require 'gulp-ng-html2js'
htmlmin    = require 'gulp-htmlmin'
inject     = require 'gulp-inject'
livereload = require 'gulp-livereload'
changed    = require 'gulp-changed'
concat     = require 'gulp-concat'
filter     = require 'gulp-filter'
open       = require 'gulp-open'
embedlr    = require 'gulp-embedlr'
bowerFiles = require 'main-bower-files'
preprocess = require 'gulp-preprocess'
sourcemaps = require 'gulp-sourcemaps'
uglify     = require 'gulp-uglify'

css_filter = filter '**/*.css', { restore: true }
js_filter  = filter '**/*.js', { restore: true }

src         = 'app'
dest        = 'public'
name        = 'arbd'
current_dir = '${PWD##*/}'

gulp.task 'inject', ['css', 'compress', 'concat_js'], ->
    gulp.src('./public/index.html')
        .pipe(inject(gulp.src(['./public/css/*.css']),
            removeTags: true
            starttag:   '<!-- inject:head:css -->'
            transform:  (filePath, file) ->
                return '<style type="text/css">' + file.contents.toString('utf8') + '</style>'
        ))
        .pipe(inject(gulp.src("#{dest}/js/#{name}-app.js"),
            removeTags: true
            starttag:   '<!-- inject:tail:js -->'
            transform:  (filePath, file) ->
                return '<script type="text/javascript" src="' + (filePath.replace ///\/#{dest}\////, '') + '"></script>'
        ))
        .pipe gulp.dest('./public')

gulp.task 'concat_js', ['coffee', 'components', 'compress'], ->
    gulp.src ["#{dest}/js/#{name}-components.js", "#{dest}/js/#{name}-templates.js", "#{dest}/js/#{name}.js"]
        .pipe sourcemaps.init({ loadMaps: true })
        .pipe concat("#{name}-app.js")
        .pipe gulp.dest("#{dest}/js")
        .pipe sourcemaps.write('./maps')


gulp.task 'clean', ->
    del.sync "#{dest}"

gulp.task 'lint', ->
    gulp.src ["#{src}/**/*.coffee", 'gulpfile.coffee']
        .pipe coffeelint()
        .pipe coffeelint.reporter()

gulp.task 'coffee', ['lint'], ->
    gulp.src "#{src}/**/*.coffee"
        .pipe changed("#{dest}/js", { extension: '.js' })
        .pipe preprocess()
        .pipe sourcemaps.init()
        .pipe coffee({ bare: true }).on('error', gutil.log)
        .pipe concat("#{name}.js")
        .pipe ngAnnotate()
        .pipe sourcemaps.write('./maps')
        .pipe gulp.dest("#{dest}/js")
        .pipe livereload()

gulp.task 'ngtemplate', ->
    gulp.src ["#{src}/**/*.html", "!#{src}/index.html"]
        .pipe changed("#{dest}/js", { extension: '.js' })
        .pipe htmlmin
            collapseBooleanAttributes:     true
            collapseWhitespace:            true
            removeAttributeQuotes:         true
            removeComments:                true
            removeEmptyAttributes:         true
            removeRedundantAttributes:     true
            removeScriptTypeAttributes:    true
            removeStyleLinkTypeAttributes: true
            minifyCSS:                     true
        .pipe ngHtml2Js({ moduleName: "#{name}-templates" })
        .pipe concat("#{name}-templates.js")
        .pipe gulp.dest("#{dest}/js")
        .pipe livereload()

gulp.task 'components', ->
    gulp.src bowerFiles()
        .pipe js_filter
        .pipe sourcemaps.init({ loadMaps: true })
        .pipe concat("#{name}-components.js")
        .pipe gulp.dest("#{dest}/js")
        .pipe sourcemaps.write('./maps')
        .pipe js_filter.restore
        .pipe css_filter
        .pipe sourcemaps.init({ loadMaps: true })
        .pipe concat("#{name}-components.css")
        .pipe sourcemaps.write('./maps')
        .pipe gulp.dest("#{dest}/css")
        .pipe livereload()

gulp.task 'css', ->
    gulp.src ["#{src}/css/*.css"]
        .pipe changed("#{dest}/css", { extension: '.css' })
        .pipe concat("#{name}.css")
        .pipe gulp.dest("#{dest}/css")
        .pipe livereload()

gulp.task 'copy', ->
    stream = gulp.src "#{src}/index.html"
    if process.env['APPLICATION_ENV'] isnt 'production'
        stream.pipe embedlr()
    stream.pipe gulp.dest(dest)

gulp.task 'compress', ['coffee', 'ngtemplate'], ->
    gulp.src "#{dest}/js/*.js"
        .pipe sourcemaps.init({ loadMaps: true })
        .pipe uglify()
        .pipe sourcemaps.write('./maps')
        .pipe gulp.dest("#{dest}/js/")
    gulp.src "#{dest}/css/*.css"
        .pipe sourcemaps.init({ loadMaps: true })
        .pipe cssmin({ keepSpecialComments: 0 })
        .pipe sourcemaps.write('./maps')
        .pipe gulp.dest("#{dest}/css/")

gulp.task 'copy_other', ->
    gulp.src 'bower_components/admin-lte/dist/img/**/*'
        .pipe gulp.dest("#{dest}/img/")
    gulp.src 'bower_components/bootstrap/fonts/*'
        .pipe gulp.dest("#{dest}/fonts/")
    gulp.src 'bower_components/font-awesome/fonts/*'
        .pipe gulp.dest("#{dest}/fonts/")
    gulp.src 'bower_components/Ionicons/fonts/*'
        .pipe gulp.dest("#{dest}/fonts/")
    gulp.src "#{src}/favicons/*"
        .pipe gulp.dest("#{dest}/")

gulp.task 'open', ->
    options = { uri: "http://#{name}.net/index.html" }
    if process.env['APPLICATION_ENV'] isnt 'production'
        options.uri = "http://#{current_dir}.etna.dev/index.html"
    gulp.src "#{src}/index.html"
        .pipe open(options)

gulp.task 'watch', ->
    server = livereload({ start: true })
    gulp.watch("#{dest}/**").on 'change', (file) ->
        server.changed file.path

    gulp.watch "#{src}/**/*.coffee", ['coffee']
    gulp.watch "#{src}/**/*.html",   ['ngtemplate']
    gulp.watch "#{src}/**/*.css",    ['css']
    gulp.watch "#{src}/index.html",  ['copy']

gulp.task 'assets',  ['copy', 'copy_other', 'css', 'components']
gulp.task 'common',  ['clean', 'assets', 'ngtemplate', 'coffee']
gulp.task 'dev',     ['common']
gulp.task 'prod',    ['common', 'compress', 'concat_js', 'inject', 'open']
gulp.task 'default', ['dev', 'open', 'watch']
