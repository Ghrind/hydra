require "../src/hydra"

app = Hydra::Application.setup

prompt_1 = Hydra::Prompt.build("prompt-1")
prompt_1.hide
prompt_1.position = "5:20"
app.add_element(prompt_1)

prompt_2 = Hydra::Prompt.build("prompt-2")
prompt_2.hide
prompt_2.position = "center"
app.add_element(prompt_2)

app.bind("prompt-1.submit", "application", "stop")

app.bind("keypress.c", "application") do |event_hub, _|
  if event_hub.has_focus?("prompt-1")
    true
  else
    event_hub.trigger("prompt-1", "show")
    event_hub.focus("prompt-1")
    false
  end
end

app.bind("keypress.d", "application") do |event_hub, _|
  if event_hub.has_focus?("prompt-2")
    true
  else
    event_hub.trigger("prompt-2", "show")
    event_hub.focus("prompt-2")
    false
  end
end

# Pressing ctrl + a will close prompt-1
app.bind("keypress.ctrl-a", "application") do |event_hub, _|
  event_hub.trigger("prompt-1", "hide")
  event_hub.focus("")
  true
end

# Pressing q will quit
app.bind("keypress.q", "application", "stop")

# Pressing s will quit in 2 seconds
app.bind("keypress.s", "application") do |event_hub, _|
  spawn do
    sleep 2
    event_hub.trigger("application", "stop")
  end
  true
end

app.start
