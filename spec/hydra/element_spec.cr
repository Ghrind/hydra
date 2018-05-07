require "spec"
require "../../src/hydra/element"

describe "Element" do
  describe "#position" do
    it "defaults as '0:0'" do
      element = Hydra::Element.new("id")
      element.position.should eq "0:0"
    end
  end
  describe "#visible" do
    it "defaults as true" do
      element = Hydra::Element.new("id")
      element.visible.should eq true
    end
  end
  describe "#id" do
    it "is defined during initialization" do
      element = Hydra::Element.new("foobar")
      element.id.should eq "foobar"
    end
  end
  describe "#width" do
    it "is fixed at 0" do
      element = Hydra::Element.new("foobar")
      element.width.should eq 0
    end
  end
  describe "#height" do
    it "is fixed at 0" do
      element = Hydra::Element.new("foobar")
      element.height.should eq 0
    end
  end
  describe "#hide" do
    it "sets visible to false" do
      element = Hydra::Element.new("id")
      element.hide
      element.visible.should eq false
    end
  end
  describe "#content" do
    it "returns a generic message" do
      element = Hydra::Element.new("id")
      element.content.should eq "Content for Hydra::Element is undefined"
    end
  end
end
