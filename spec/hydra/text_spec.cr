require "spec"
require "../src/hydra/text"

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

      text.content.should eq ["┌───┐",
                               "│fo │",
                               "│bar│",
                               "└───┘"].join("\n")
    end
    context "when the label is longer than the content" do
      it "expends the box accordingly" do
        text = Hydra::Text.new("", { :label => "foobar" })
        text.value = "fo\nbar"

        text.content.should eq ["┌─foobar─┐",
                                "│fo      │",
                                "│bar     │",
                                "└────────┘"].join("\n")
      end
    end
  end
end
