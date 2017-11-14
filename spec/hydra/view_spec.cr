require "spec"
require "../src/hydra/view"

class TestElement < Hydra::Element
  property :position
  def initialize
    super("")
  end

  def content
    @value
  end

  def height
    @value.split("\n").size
  end

  def width
    @value.split("\n")[0].size
  end
end

describe "View" do

  describe "#close" do
    it "closes the interface" do
      view = Hydra::View.new(Hydra::ViewTestInterface, 1, 1)
      view.close
      view.closed?.should eq true
    end
  end

  describe ".new" do
    it "opens the interface" do
      view = Hydra::View.new(Hydra::ViewTestInterface, 1, 1)
      view.closed?.should eq false
    end
  end

  describe "#render_element" do
    it "renders the content of an element at the right position" do
      view = Hydra::View.new(Hydra::ViewTestInterface, 5, 10)

      element = TestElement.new
      element.position = "2:1"
      element.value = "abc\ndef\nghi"

      view.render_element(element)
      view.dump.should eq ["          ",
                           "          ",
                           " abc      ",
                           " def      ",
                           " ghi      "].join("\n")
    end

    context "when the element is centered" do
      it "renders the content of the element at the center of the canvas" do
        view = Hydra::View.new(Hydra::ViewTestInterface, 5, 10)

        element = TestElement.new
        element.position = "center"
        element.value = "abc\ndef\nghi"

        view.render_element(element)
        view.dump.should eq ["          ",
                             "   abc    ",
                             "   def    ",
                             "   ghi    ",
                             "          "].join("\n")
      end
    end

  end
  describe "#render" do
    context "when the element has a template" do
      it "renders the content of the template" do
        view = Hydra::View.new(Hydra::ViewTestInterface, 5, 10)

        element = TestElement.new
        element.position = "center"
        element.value = "foobar" # In a real case scenario, value should be be initialized if a template is given
        element.template = "{{a}}"

        view.render([element])
        view.dump.should eq ["          ",
                             "          ",
                             "  {{a}}   ",
                             "          ",
                             "          "].join("\n")
      end

      it "replaces the bindings with values from the state" do
        view = Hydra::View.new(Hydra::ViewTestInterface, 5, 10)

        element = TestElement.new
        element.position = "center"
        element.template = "{{a}}"

        view.render([element], { "a" => "1234567890"})
        view.dump.should eq ["          ",
                             "          ",
                             "1234567890",
                             "          ",
                             "          "].join("\n")
      end
    end
  end
end
