require "crt"
require "./src/*"
require "socket"
require "logger"
require "json"

LOGGER = Logger.new(File.new("./debug.log", "w"))
LOGGER.level = Logger::DEBUG

LOGGER.debug("Starting...")

app = Application.new
app.start
