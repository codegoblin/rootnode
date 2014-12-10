# db.coffee -- initialize db layer here
# Load db library + requires
Colors	  = require 'colors'
Database  = require('../lib/db')

module.exports = exports = (app, cb) ->
  model_dir = app.get('root') + '/app/models/'
  db_config = app.get('config').mongoose
  Database db_config, model_dir, (models) ->
    app.set 'models', models
    cb()
