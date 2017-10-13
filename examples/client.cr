require "socket"
require "json"

s = TCPSocket.new "localhost", 8080

payload = [
  { "element" => "log_box", "height" => 11, "width" => 60 },
  { "bind" => "keypress.page_up", "target" => "logbox", "behavior" => "scroll_up" },
  { "bind" => "keypress.page_down", "target" => "logbox", "behavior" => "scroll_down" },
  { "bind" => "keypress.c", "target" => "client", "behavior" => "say_hello" }
]

10.times do |i|
  payload.push({ "do" => "add_message", "target" => "logbox", "params" => i.to_s })
end

s.puts payload.to_json

while true
  puts s.gets
end

s.close
