# Boot.coffee -- Put all 'boot up' logic here

# Requires
Async = require 'async'

# Boot Module
module.exports = exports = (app) ->

  # General app settings
  app.set 'config',       require 'config'
  app.set 'port',         process.env.PORT || 5000
  app.set 'views',        app.get('root') + '/app/views'
  app.set 'view engine',  'jade'
  app.set 'view options', layout: false

  # Load app stack
  Async.series [
    (cb) -> require("./db")(app, cb),         # Load DB
    (cb) -> require("./middleware")(app, cb), # Load middleware
    (cb) -> require("./routes")(app, cb)      # Load routes
  ], (err, results) ->
    throw err if err

    ###############################
    # PUT GLOBAL VIEW LOCALS HERE #
    ###############################

    app.locals
      #google_analytics_id: app.get('config').google_analytics.id
      #page_title: app.get('config').app.page_title

    # Start listening
    app.listen app.get('port'), ->
      # Set boot messages here
      console.log "Booting in #{app.get('env')} environment"
      console.log 'Express server listening on port ' + app.get('port')
