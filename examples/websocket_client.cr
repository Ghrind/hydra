# This is a client that is supposed to communicate with the application.cr example
require "socket"
require "json"

s = TCPSocket.new "localhost", 8080

#payload = [
#  { "element" => "log_box", "height" => 11, "width" => 60 },
#  { "bind" => "keypress.page_up", "target" => "logbox", "behavior" => "scroll_up" },
#  { "bind" => "keypress.page_down", "target" => "logbox", "behavior" => "scroll_down" },
#  { "bind" => "keypress.c", "target" => "client", "behavior" => "say_hello" }
#]
#
#10.times do |i|
#  payload.push({ "do" => "add_message", "target" => "logbox", "params" => i.to_s })
#end
#
#s.puts payload.to_json

while true
  msg = s.gets
  puts msg
  s.puts "Coucou #{msg}"
end

s.close
