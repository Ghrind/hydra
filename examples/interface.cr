require "../src/hydra"

eh = Hydra::EventHub.new

l = Hydra::Logger.build(File.new("./debug.log", "w"))
l.level = Logger::DEBUG
eh.register("logger", l.event_interface)
eh.trigger("logger", "debug", { :message => "Starting..."})
eh.bind("*", "logger", "debug")

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

eh.bind("keypress.c") do |event_hub|
  event_hub.interfaces("prompt-1").trigger("show")
end

# Pressing q will quit
eh.bind("keypress.q", "application", "stop")

# Pressing s will quit in 2 seconds
eh.bind("keypress.s") do |event_hub|
  spawn do
    sleep 2
    event_hub.interfaces("application").trigger("stop")
  end
end

a.start
