require "../src/hydra"

eh = Hydra::EventHub.new

l = Hydra::Logger.build(File.new("./debug.log", "w"))
l.level = Logger::DEBUG
eh.register("logger", l.event_interface)
eh.trigger("logger", "debug", { :message => "Starting..."})
eh.bind("*", "logger", "debug")

v = Hydra::View.new(x: 50, y: 100)
eh.register("view", v.event_interface)

a = Hydra::Application.new(v, eh)
prompt_1 = Hydra::Prompt.build("prompt-1")
prompt_1.hide
eh.register("prompt-1", prompt_1.event_interface)
v.add_element(prompt_1)
eh.bind("keypress.c", "prompt-1", "show")
eh.bind("prompt-1.submit", "application", "exit")

a.start
