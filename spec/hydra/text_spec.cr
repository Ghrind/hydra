require "spec"
require "../../src/hydra/text"

describe "Text" do
  describe "#width" do
    it "returns the full width of the content" do
      text = Hydra::Text.new("")
      text.value = "fo\nbar"

      text.width.should eq 5
    end
  end

  describe "#height" do
    it "returns the full height of the content" do
      text = Hydra::Text.new("")
      text.value = "fo\nbar"

      text.height.should eq 4
    end
  end

  describe "#content" do
    it "returns the value in a box" do
      text = Hydra::Text.new("")
      text.value = "fo\nbar"

      text.content.string.should eq ["┌───┐",
                                     "│fo │",
                                     "│bar│",
                                     "└───┘"].join("\n")
    end
    context "when the label is longer than the content" do
      it "expends the box accordingly" do
        text = Hydra::Text.new("", { :label => "foobar" })
        text.value = "fo\nbar"

        text.content.string.should eq ["┌─foobar─┐",
                                       "│fo      │",
                                       "│bar     │",
                                       "└────────┘"].join("\n")
      end
    end
    context "when there is a tag on a newline" do
      it "justifies displays the border correctly" do
        text = Hydra::Text.new("")
        text.value = "The word <red-fg>red</red-fg> is red\n<green-fg>This text is green</green-fg>"

        text.content.stripped.should eq ["┌───────────────────┐",
                                         "│The word red is red│",
                                         "│This text is green │",
                                         "└───────────────────┘"].join("\n")
      end
    end
  end
end
