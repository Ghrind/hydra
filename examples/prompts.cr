require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "prompt-2",
  :type => "prompt",
  :position => "center",
  :visible => "false",
  :label => "Prompt 2"
})

app.add_element({
  :id => "prompt-1",
  :type => "prompt",
  :position => "center",
  :visible => "false",
  :label => "Prompt 1"
})

app.add_element({
  :id => "logbox",
  :type => "logbox",
  :position => "40:0",
  :label => "Messages"
})

app.add_element({
  :id => "",
  :type => "text",
  :value => "Press c to show Prompt 1\nPress d to show Prompt 2\nPress ctrl-x to hide prompts\nPress q to quit",
  :label => "Commands"
})

# Prompt 1

app.bind("keypress.c", "application") do |event_hub|
  if event_hub.has_focus?("prompt-1")
    true
  else
    event_hub.trigger("prompt-1", "show")
    event_hub.focus("prompt-1")
    false
  end
end

app.bind("keypress.enter", "prompt-1") do |event_hub, event, elements|
  if event_hub.has_focus?("prompt-1")
    event_hub.trigger("prompt-1", "hide")
    event_hub.unfocus
    element = elements.by_id("prompt-1")
    event_hub.trigger("logbox", "add_message", { "message" => "Prompt 1: '#{element.value}'" })
    event_hub.trigger("prompt-1", "clear")
    false
  else
    true
  end
end

# End of Promt 1

# Prompt 2

app.bind("keypress.d", "application") do |event_hub|
  if event_hub.has_focus?("prompt-2")
    true
  else
    event_hub.trigger("prompt-2", "show")
    event_hub.focus("prompt-2")
    false
  end
end

app.bind("keypress.enter", "prompt-2") do |event_hub, event, elements|
  if event_hub.has_focus?("prompt-2")
    event_hub.trigger("prompt-2", "hide")
    event_hub.unfocus
    element = elements.by_id("prompt-2")
    event_hub.trigger("logbox", "add_message", { "message" => "Prompt 2: '#{element.value}'" })
    event_hub.trigger("prompt-2", "clear")
    false
  else
    true
  end
end

# End of Promt 2

# Pressing ctrl + x will close all prompts
app.bind("keypress.ctrl-x", "application") do |event_hub|
  event_hub.trigger("prompt-1", "hide")
  event_hub.trigger("prompt-1", "clear")
  event_hub.trigger("prompt-2", "hide")
  event_hub.trigger("prompt-2", "clear")
  event_hub.unfocus
  true
end

# Pressing q will quit
app.bind("keypress.q", "application", "stop")

app.run
