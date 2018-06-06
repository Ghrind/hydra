require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "my-list",
  :type => "list",
  :height => "4",
  :label => "Select an item"
})

app.add_element({
  :id => "",
  :type => "text",
  :position => "8:0",
  :template => "{{selected}}",
  :label => "Selected"
})

app.bind("ready") do |_, _, elements, state|
  list = elements.by_id("my-list").as(Hydra::List)
  list.add_item "Apples"
  list.add_item "Bananas"
  list.add_item "Cherries"
  list.add_item "Pears"
  state["selected"] = list.value
  true
end

app.bind("keypress.j") do |event_hub, _, elements, state|
  event_hub.trigger("my-list", "select_down")
  list = elements.by_id("my-list")
  state["selected"] = list.value
  true
end

app.bind("keypress.k") do |event_hub, _, elements, state|
  event_hub.trigger("my-list", "select_up")
  list = elements.by_id("my-list")
  state["selected"] = list.value
  true
end

# Pressing q will quit
app.bind("keypress.q", "application", "stop")

app.run
app.teardown
