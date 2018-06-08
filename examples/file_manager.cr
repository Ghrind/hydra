require "../src/hydra"

include Hydra

class FileManager < Application
  private def update_state
    filename = current_filename
    if filename
      @state["file_name"] = filename
      @state["file_size"] = File.size(filename).to_s
    end
  end

  def rename_current_file(new_name : String)
    if current_filename
      File.rename(current_filename.as(String), new_name)
      update_file_list
      message("Renaming #{current_filename} -> #{new_name}")
    end
  end

  def message(text : String)
    @event_hub.trigger("logbox", "add_message", { "message" => text })
  end

  def update_file_list
    list = @elements.by_id("file-list").as(List)
    list.clear
    Dir.glob("*").sort.each do |entry|
      list.add_item(entry)
    end
  end

  private def current_filename
    list = @elements.by_id("file-list").as(List)
    if list.selected
      list.value
    end
  end

  private def update_screen
    update_state
    super
  end
end

app = FileManager.setup

# File list

file_list = List.new("file-list", {
  :label => "Files",
  :position => "0:0",
  :width => "40",
  :height => "25",
})
app.add_element(file_list)

app.bind("ready") do |event_hub, _, elements, _|
  app.update_file_list
  event_hub.focus("file-list")
  true
end

app.bind("keypress.j") do |event_hub, _, elements, state|
  event_hub.trigger("file-list", "select_down")
  true
end

app.bind("keypress.k") do |event_hub, _, elements, state|
  event_hub.trigger("file-list", "select_up")
  true
end

# Info panel

info_panel_template = "Name: {{file_name}}\n" \
                      "Size: {{file_size}} b"

info_panel = Text.new("info-panel", {
  :height => "16",
  :label => "File info",
  :position => "0:39",
  :template => info_panel_template,
  :width => "40",
})
app.add_element(info_panel)

# Rename prompt

rename_prompt = Prompt.new("rename-prompt", {
  :height => "3",
  :label => "Rename file:",
  :position => "10:35",
  :visible => "false",
  :width => "30",
  :z_index => "1",
})
app.add_element(rename_prompt)

app.bind("file-list", "keypress.r") do |event_hub, _, elements, _|
  prompt = elements.by_id("rename-prompt").as(Prompt)
  prompt.show
  event_hub.focus(prompt.id)
  false
end

app.bind("rename-prompt", "keypress.enter") do |event_hub, _, elements, _|
  prompt = elements.by_id("rename-prompt").as(Prompt)
  app.rename_current_file(prompt.value)
  prompt.hide
  prompt.clear
  event_hub.focus("file-list")
  false
end

# Commands

commands = Text.new("commands", {
  :height => "10",
  :label => "Commands",
  :value => "Use j and k to select file\nPress r to rename file\nPress q to quit",
  :position => "15:39",
  :width => "40",
})
app.add_element(commands)

# Logbox

logbox = Logbox.new("logbox", {
  :height => "6",
  :label => "Messages",
  :position => "24:0",
  :width => "79",
})
app.add_element(logbox)

# Exit conditions

# Pressing q will quit
app.bind("file-list", "keypress.q", "application", "stop")

app.bind("keypress.ctrl-c", "application", "stop")

app.run

app.teardown
