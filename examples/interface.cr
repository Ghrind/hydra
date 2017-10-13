require "../src/hydra"

v = Hydra::View.new(x: 50, y: 100)
eh = Hydra::EventHub.new
a = Hydra::Application.new(v, eh)
eh.register("view", v.event_interface)
prompt_1 = Hydra::Prompt.build("prompt-1")
prompt_1.hide
eh.register("prompt-1", prompt_1.event_interface)
v.add_element(prompt_1)
eh.bind("keypress.c", "prompt-1", "show")
eh.bind("prompt-1.submit", "application", "exit")

a.start
