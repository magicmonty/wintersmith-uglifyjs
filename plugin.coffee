uglify = require 'uglify-js'
fs = require 'fs'
path = require 'path'

module.exports = (wintersmith, callback) ->
	
  logger = wintersmith.logger
  
  class Uglify2Plugin extends wintersmith.ContentPlugin

    constructor: (@_filename, @_base) ->

    getFilename: ->
      path.join(path.dirname(@_filename), path.basename(@_filename, path.extname(@_filename)) + '.js')

    render: (locals, contents, templates, callback) ->
      self = this
      file = path.join(self._base, self._filename)
      logger.verbose "Loading uglify config from #{self._filename}"
      fs.readFile file, (error, buffer) ->
        text = buffer.toString()
        if error
          callback error
        else
          try
            config = JSON.parse text
            toUglify = (path.join(self._base, '..', 'js', item) for item in config.uglify)
            result = uglify.minify toUglify
            callback null, new Buffer result.code
          catch error
            callback error
      
      # do something with the text!
  
  Uglify2Plugin.fromFile = (filename, base, callback) ->
    callback null, new Uglify2Plugin filename, base

  wintersmith.registerContentPlugin 'wintersmith-uglify2', '**/*.ugljs', Uglify2Plugin
  callback() # tell the plugin manager we are done
