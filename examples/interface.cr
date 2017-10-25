require "../src/hydra"

eh = Hydra::EventHub.new

v = Hydra::View.new(x: 50, y: 100)
eh.register("view", v.event_interface)

a = Hydra::Application.build(v, eh)
eh.register("application", a.event_interface)

prompt_1 = Hydra::Prompt.build("prompt-1")
prompt_1.hide
eh.register("prompt-1", prompt_1.event_interface)
v.add_element(prompt_1)

eh.bind("prompt-1.submit", "application", "stop")

eh.bind("keypress.c", "application") do |event_hub, _|
  if event_hub.has_focus?("prompt-1")
    true
  else
    event_hub.trigger("prompt-1", "show")
    event_hub.focus("prompt-1")
    false
  end
end

# Pressing ctrl + a will close prompt-1
eh.bind("keypress.ctrl-a", "application") do |event_hub, _|
  event_hub.trigger("prompt-1", "hide")
  event_hub.focus("")
  true
end

# Pressing q will quit
eh.bind("keypress.q", "application", "stop")


# Pressing s will quit in 2 seconds
eh.bind("keypress.s", "application") do |event_hub, _|
  spawn do
    sleep 2
    event_hub.trigger("application", "stop")
  end
  true
end

a.start
