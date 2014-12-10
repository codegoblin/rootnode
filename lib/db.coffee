Mongoose    = require 'mongoose'
FileSystem  = require 'fs'
Path        = require 'path'

module.exports = exports = (config, models_dir, cb) ->

  # NOTE: It's questionable whether or not this should be here
  # or this responsibility should be relegated to the caller of this class
  load_models = (dir) ->
    models = {}
    for file in FileSystem.readdirSync(dir)
      model = Path.basename(file, Path.extname(file))
      models[model] = require(dir + model)
    models

  # Add any mongoose plugins here
  # ============================
  # Caching
  cache_options =
    max: 20
    maxAge: 1000 * 30
    debug: false

  require('mongoose-cache').install Mongoose, cache_options

  # Establish connection to database
  # ================================
  console.log 'Connecting to DB'.yellow, config.host

  Mongoose.connect config.host, () ->
    console.log "MongoDB connected".green
    cb(load_models(models_dir))

  Mongoose.connection.on 'error', (err) ->
    console.error 'connection error:'.red, err
    process.exit()
