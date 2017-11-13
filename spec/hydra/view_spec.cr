require "spec"
require "../src/hydra/view"

class TestElement < Hydra::Element
  property :position, :width, :height, :content
  def initialize
    @id = ""
    @visible = true
    @position = "0:0"
    @width = 0
    @height = 0
    @content = ""
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
      element.content = "abc\ndef\nghi"

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
        element.width = 3
        element.height = 3
        element.position = "center"
        element.content = "abc\ndef\nghi"

        view.render_element(element)
        view.dump.should eq ["          ",
                             "   abc    ",
                             "   def    ",
                             "   ghi    ",
                             "          "].join("\n")
      end
    end
  end
end
