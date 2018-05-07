require "../src/hydra"
require "socket"
require "json"

puts "Waiting for client to connect..."
puts "Use `crystal run example/websocket_client.cr` to run the client"
server = TCPServer.new("0.0.0.0", 8080)
socket = server.accept

app = Hydra::Application.setup

app.add_element({
  :id => "message",
  :template => "{{message}}",
  :type => "text"
})

app.add_element({
  :id => "prompt",
  :type => "prompt",
  :position => "4:0"
})

app.bind("ready", "application") do |event_hub, _, _, state|
  state["message"] = "..."
  event_hub.focus("prompt")
  true
end

app.bind("keypress.enter", "prompt") do |_, _, elements, state|
  prompt = elements.by_id("prompt")
  socket.puts Hydra::ExtendedString.escape(prompt.value)
  message = socket.gets
  state["message"] = message if message
  true
end

app.run
