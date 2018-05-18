require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "commands",
  :type => "text",
  :value => "Press q to quit immediately\nPress s to quit in 2 seconds",
  :label => "Commands"
})

# Pressing q will quit
app.bind("keypress.q", "application", "stop")

# Pressing s will quit in 2 seconds
app.bind("keypress.s", "application") do |event_hub|
  spawn do
    sleep 2
    event_hub.trigger("application", "stop")
  end
  true
end

app.run
app.teardown
