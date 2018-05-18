require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "logbox",
  :type => "logbox",
  :position => "40:0",
  :label => "Messages"
})

app.bind("keypress.*", "application") do |event_hub, event|
  event_hub.trigger("logbox", "add_message", { "message" => "#{Hydra::ExtendedString.escape(event.keypress.inspect)}" })
  true
end

app.run
