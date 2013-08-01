uglify = require 'uglify-js'
fs = require 'fs'
path = require 'path'

module.exports = (env, callback) ->

  logger = env.logger

  class Uglify2Plugin extends env.ContentPlugin

    constructor: (@filepath) ->

    getFilename: ->
      @filepath.relative.replace /\.ugljs$/, '.js'

    getView: -> (env, locals, contents, templates, callback) ->
      filepath = @filepath
      logger.verbose "Uglify2Plugin: Loading uglify config from #{@filepath.relative}"
      fs.readFile @filepath.full, (error, buffer) ->
        if error
          callback error
        else
          try
            options = JSON.parse buffer.toString()
            basePath = path.normalize path.join(path.dirname(filepath.full), "..", "..", "js")
            logger.verbose "Uglify2Plugin: Loading scripts from #{basePath}"
            toUglify = (path.join(basePath, item) for item in options.uglify)
            result = uglify.minify toUglify
            callback null, new Buffer result.code
          catch error
            callback error


  Uglify2Plugin.fromFile = (filepath, callback) ->
    callback null, new Uglify2Plugin filepath

  env.registerContentPlugin 'scripts', '**/*.ugljs', Uglify2Plugin
  callback()
