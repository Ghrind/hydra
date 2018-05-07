require "../src/hydra"

app = Hydra::Application.setup

app.bind("keypress-q", "application", "close")



app.add_element({
  :type => "text",
  :id => "text",
  :value => "The word <red-fg>red</red-fg> is red\n<green-fg>This text is green</green-fg>\nThis is <bold>bold</bold>\n<blue-fg>This is blue and <bold>bold</bold></blue-fg>"
})

app.run
