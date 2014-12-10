# routes.coffee -- include/config routes and route-specific middleware here

# Requires
# ========
FileSystem  = require 'fs'
Path        = require 'path'
Express     = require 'express'

# Module
# ======

module.exports = exports = (app, cb) ->

  # Vars
  # ====

  route_dir = app.get('root') + '/app/routes/'

  # Methods
  # =======

  # Recursively load modules and folders as routes
  load_routes = (dir) ->
    routes = {}
    for file in FileSystem.readdirSync(dir)
      if FileSystem.statSync(dir + file).isDirectory()
        routes[file] = load_routes(dir + "#{file}/")
      else
        route = Path.basename(file, Path.extname(file))
        # We're ignoring hidden files
        routes[route] = require(dir + route) if route.length > 0
    routes

  # Load routes
  # ===========

  app.set 'routes', load_routes(route_dir)
  routes = app.get('routes')

  # Define custom route middleware here
  # ===================================

  # Ensure auth'd w/ config
  ensure_auth = (user, pass) ->
    auth = app.get('config').basic_auth
    user == auth.username && pass == auth.password

  # Define routes here
  # ==================

  app.get '/', routes.application.index

  cb() # Done Loading Routes
