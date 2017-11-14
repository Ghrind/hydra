require "spec"
require "../src/hydra/label"

describe "Label" do
  describe "#width" do
    it "returns the full width of the content" do
      label = Hydra::Label.new("")
      label.value = "fo\nbar"

      label.width.should eq 5
    end
  end

  describe "#height" do
    it "returns the full height of the content" do
      label = Hydra::Label.new("")
      label.value = "fo\nbar"

      label.height.should eq 4
    end
  end

  describe "#content" do
    it "returns the value in a box" do
      label = Hydra::Label.new("")
      label.value = "fo\nbar"

      label.content.should eq ["┌───┐",
                               "│fo │",
                               "│bar│",
                               "└───┘"].join("\n")
    end
  end
end
