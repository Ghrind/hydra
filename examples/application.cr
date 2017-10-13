require "../src/hydra"
require "socket"
require "logger"
require "json"

class Application
  def initialize
    @view = uninitialized Hydra::View
    @event_hub = uninitialized Hydra::EventHub
  end
  def start
    server = TCPServer.new("0.0.0.0", 8080)
    @view = Hydra::View.new
    socket = server.accept
    @event_hub = Hydra::EventHub.new(@view, socket)
    @view.render
    spawn do
      loop do
        message = socket.gets
        if message
          message_received(JSON.parse(message))
        end
        sleep 0.01
      end
    end
    loop do
      char = @view.getch
      sleep 0.01
      next unless char >= 0
      LOGGER.debug "event triggered: #{Hydra::EventHub.char_to_event(char)}"
      @event_hub.broadcast(Hydra::EventHub.char_to_event(char))
      @view.render
    end
    Fiber.yield
    Crt.done
  end

  def message_received(payload : JSON::Any)
    payload.each do |instruction|
      if instruction["element"]?
        case instruction["element"]
        when "log_box"
          @view.add_element(Hydra::LogBox.new(instruction["width"].as_i, instruction["height"].as_i))
        end
      elsif instruction["bind"]?
        @event_hub.bind(instruction["bind"].as_s, instruction["target"].as_s, instruction["behavior"].as_s)
      elsif instruction["do"]?
        @event_hub.trigger(instruction["target"].as_s, instruction["do"].as_s, instruction["params"].as_s)
      end
    end
    @view.render
  end
end

LOGGER = Logger.new(File.new("./debug.log", "w"))
LOGGER.level = Logger::DEBUG

LOGGER.debug("Starting...")

app = Application.new
app.start
