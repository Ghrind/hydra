require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "prompt-1",
  :type => "prompt",
  :position => "center",
  :visible => "false",
  :label => "User name"
})

app.add_element({
  :id => "",
  :type => "text",
  :position => "7:0",
  :template => "{{player.name}}",
  :label => "User name"
})

app.add_element({
  :id => "commands",
  :type => "text",
  :value => "Press c to show Prompt\nPress ctrl-x to hide prompt\nPress q to quit",
  :label => "Commands"
})

app.bind("ready") do |_, _, _, state|
  state["player.name"] = "John Doe"
  true
end

app.bind("keypress.c") do |event_hub|
  if event_hub.has_focus?("prompt-1")
    true
  else
    event_hub.trigger("prompt-1", "show")
    event_hub.focus("prompt-1")
    false
  end
end

app.bind("prompt-1", "keypress.enter") do |event_hub, event, elements, state|
  event_hub.trigger("prompt-1", "hide")
  event_hub.unfocus
  element = elements.by_id("prompt-1")
  state["player.name"] = Hydra::ExtendedString.escape(element.value)
  event_hub.trigger("prompt-1", "clear")
  false
end

# Pressing ctrl + x will close prompt
app.bind("keypress.ctrl-x") do |event_hub|
  event_hub.trigger("prompt-1", "hide")
  event_hub.unfocus
  true
end

# Pressing q will quit
app.bind("application", "keypress.q", "application", "stop")

app.run
app.teardown
