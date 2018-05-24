require "spec"
require "../../src/hydra/list"

describe "List" do
  describe "#inner_height" do
    it "is equal to the height without border" do
      list = Hydra::List.new("")
      list.height = 3
      list.inner_height.should eq 1

      list = Hydra::List.new("")
      list.height = 4
      list.inner_height.should eq 2
    end
  end
  context "when it is empty" do
    it "shows an empty box" do
      list = Hydra::List.new("")
      list.height = 3
      list.width = 10
      list.content.stripped.should eq ["┌────────┐",
                                       "│        │",
                                       "└────────┘"].join("\n")
    end
  end
  context "when there are items" do
    it "shows the item" do
      list = Hydra::List.new("")
      list.height = 4
      list.width = 10
      list.add_item("foobar")
      list.add_item("barfoo")
      list.content.stripped.should eq ["┌────────┐",
                                       "│foobar  │",
                                       "│barfoo  │",
                                       "└────────┘"].join("\n")
    end
  end
  context "when the items overflow from the list's height" do
    it "shows the scroll down indicator" do
      list = Hydra::List.new("")
      list.height = 3
      list.width = 10
      list.add_item("foobar")
      list.add_item("barfoo")
      list.content.stripped.should eq ["┌────────┐",
                                       "│foobar  │",
                                       "└────────↓"].join("\n")
    end

    context "once we scroll down" do
      it "shows the scroll up indicator" do
        list = Hydra::List.new("")
        list.height = 3
        list.width = 10
        list.add_item("foobar")
        list.add_item("barfoo")
        list.scroll(-1)
        list.content.string.should eq ["┌────────↑",
                                       "│barfoo  │",
                                       "└────────┘"].join("\n")
      end
    end
    context "when there items above and below" do
      it "shows both scroll indicators" do
        list = Hydra::List.new("")
        list.height = 4
        list.width = 10
        list.add_item("foobar")
        list.add_item("barfoo")
        list.add_item("barboo")
        list.add_item("farboo")
        list.scroll(-1)
        list.content.string.should eq ["┌────────↑",
                                       "│barfoo  │",
                                       "│barboo  │",
                                       "└────────↓"].join("\n")
      end
    end
    context "when an item is selected" do
      it "should have a visual cue" do
        list = Hydra::List.new("")
        list.height = 4
        list.width = 10
        list.add_item("foobar")
        list.add_item("barfoo")
        list.select_item(0)
        list.content.string.should eq ["┌────────┐",
                                       "│<inverted>foobar</inverted>  │",
                                       "│barfoo  │",
                                       "└────────┘"].join("\n")
      end
    end
  end
end
