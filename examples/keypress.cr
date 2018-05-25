require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "logbox",
  :type => "logbox",
  :label => "Messages"
})

app.bind("keypress.*") do |event_hub, event|
  event_hub.trigger("logbox", "add_message", { "message" => "#{Hydra::ExtendedString.escape(event.keypress.inspect)}" })
  true
end

# Pressing ctrl-c will quit
app.bind("keypress.ctrl-c", "application", "stop")

app.run
app.teardown
