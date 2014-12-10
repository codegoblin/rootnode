Coffee  = require 'coffee-script'
Express = require 'express'

# Boot
module.exports = require('./config/boot')

process.on "message", (message) ->
	console.log message

process.on 'uncaughtException', (err) ->
  console.error "MAJOR CRASH ERROR".red, err, err.stack
  process.exit()
