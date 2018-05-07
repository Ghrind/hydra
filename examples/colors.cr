require "../src/hydra"

app = Hydra::Application.setup

app.bind("keypress-q", "application", "close")



app.add_element({
  :type => "text",
  :id => "text",
  :value => "The word <red-fg>red</red-fg> is red"
})

app.run
