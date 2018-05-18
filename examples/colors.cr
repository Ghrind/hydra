require "../src/hydra"

app = Hydra::Application.setup

app.bind("keypress-q", "application", "close")



app.add_element({
  :type => "text",
  :id => "text",
  :value => "The word <red-fg>red</red-fg> is red\n<green-fg>This text is green</green-fg>\n<blue-fg>This is blue and <red-fg>red</red-fg></blue-fg>"
})

# Pressing ctrl-c will quit
app.bind("keypress.ctrl-c", "application", "stop")

app.run
app.teardown
