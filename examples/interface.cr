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
eh.bind("keypress.enter", "prompt-1", "submit")

eh.bind("keypress.c", "application") do |event_hub, _|
  if event_hub.has_focus?("prompt-1")
    true
  else
    event_hub.interfaces("prompt-1").trigger("show")
    event_hub.focus("prompt-1")
    false
  end
end

eh.bind("keypress.*", "prompt-1") do |event_hub, event|
  if event_hub.has_focus?("prompt-1") && event.char
    event_hub.interfaces("prompt-1").trigger("append", { :char => event.char })
    false
  else
    true
  end
end

# Pressing q will quit
eh.bind("keypress.q", "application", "stop")

# Pressing s will quit in 2 seconds
eh.bind("keypress.s", "application") do |event_hub, _|
  spawn do
    sleep 2
    event_hub.interfaces("application").trigger("stop")
  end
  true
end

a.start
