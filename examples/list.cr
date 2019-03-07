require "../src/hydra"

app = Hydra::Application.setup

app.add_element({
  :id => "my-list",
  :type => "list",
  :height => "10",
  :label => "Select an item"
})

app.add_element({
  :id => "",
  :type => "text",
  :position => "12:0",
  :template => "Yummy yummy {{selected}}!",
  :label => "Selected",
  :width => "30"
})

app.bind("ready") do |_, _, elements, state|
  list = elements.by_id("my-list").as(Hydra::List)
  list.add_item "Apple"
  list.add_item "Banana"
  list.add_item "Cherries"
  list.add_item "Date"
  list.add_item "Elderberry"
  list.add_item "Fig"
  list.add_item "Grape"
  list.add_item "Honeyberry"
  list.add_item "Jackfruit"
  list.add_item "Kumquat"
  list.add_item "Lemon"
  list.add_item "Mango"
  list.add_item "Nectarine"
  list.add_item "Orange"
  list.add_item "Pear"

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
