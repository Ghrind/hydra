require "spec"
require "../../src/hydra/view"

def dump_view(view : Hydra::View) : String
  dump = Array(String).new
  view.grid.lines.each do |line|
    dump << line.map { |cell| cell.char }.join("")
  end
  dump.join("\n")
end

class TestElement < Hydra::Element
  property :position

  def content() Hydra::ExtendedString
    Hydra::ExtendedString.new(@value)
  end

  def height
    @value.split("\n").size
  end

  def width
    @value.split("\n")[0].size
  end
end

describe "View" do
  describe "#render_element" do
    it "renders the content of an element at the right position" do
      view = Hydra::View.new(5, 10)

      element = TestElement.new("1")
      element.position = "2:1"
      element.value = "abc\ndef\nghi"

      view.render_element(element)
      dump_view(view).should eq ["          ",
                                 "          ",
                                 " abc      ",
                                 " def      ",
                                 " ghi      "].join("\n")
    end

    context "when the element is centered" do
      it "renders the content of the element at the center of the canvas" do
        view = Hydra::View.new(5, 10)

        element = TestElement.new("1")
        element.position = "center"
        element.value = "abc\ndef\nghi"

        view.render_element(element)
        dump_view(view).should eq ["          ",
                                   "   abc    ",
                                   "   def    ",
                                   "   ghi    ",
                                   "          "].join("\n")
      end
    end

  end
  describe "#render" do
    context "with the border filter" do
      context "when two borders are overlapping" do
        it "merges borders" do
          view = Hydra::View.new(5, 10)
          view.filters << Hydra::BorderFilter

          box = ["┌─┐",
                 "│ │",
                 "└─┘"].join("\n")

          element_1 = TestElement.new("1")
          element_1.position = "0:0"
          element_1.value = box

          element_2 = TestElement.new("2")
          element_2.position = "0:2"
          element_2.value = box

          view.render([element_1, element_2])
          dump_view(view).should eq ["┌─┬─┐     ",
                                     "│ │ │     ",
                                     "└─┴─┘     ",
                                     "          ",
                                     "          "].join("\n")
        end
      end
      context "when the element's position is bottom-left" do
        it "renders the element in the bottom left corner" do
          view = Hydra::View.new(4, 4)
          element = TestElement.new("1")
          element.position = "bottom-left"
          element.value = "##\n##"

          view.render([element])

          dump_view(view).should eq ["    ",
                                     "    ",
                                     "##  ",
                                     "##  "].join("\n")
        end
      end
      context "when four borders are overlapping" do
        it "merges borders" do
          view = Hydra::View.new(5, 10)
          view.filters << Hydra::BorderFilter

          box = ["┌─┐",
                 "│ │",
                 "└─┘"].join("\n")

          element_1 = TestElement.new("1")
          element_1.position = "0:0"
          element_1.value = box

          element_2 = TestElement.new("2")
          element_2.position = "0:2"
          element_2.value = box

          element_3 = TestElement.new("3")
          element_3.position = "2:0"
          element_3.value = box

          element_4 = TestElement.new("4")
          element_4.position = "2:2"
          element_4.value = box

          view.render([element_1, element_2, element_3, element_4])
          dump_view(view).should eq ["┌─┬─┐     ",
                                     "│ │ │     ",
                                     "├─┼─┤     ",
                                     "│ │ │     ",
                                     "└─┴─┘     "].join("\n")
        end
      end
    end
    context "when the element has a template" do
      it "renders the content of the template" do
        view = Hydra::View.new(5, 10)

        element = TestElement.new("1")
        element.position = "center"
        element.value = "foobar" # In a real case scenario, value should be be initialized if a template is given
        element.template = "{{a}}"

        view.render([element])
        dump_view(view).should eq ["          ",
                                   "          ",
                                   "  {{a}}   ",
                                   "          ",
                                   "          "].join("\n")
      end

      it "replaces the bindings with values from the state" do
        view = Hydra::View.new(5, 10)

        element = TestElement.new("1")
        element.position = "center"
        element.template = "{{a}}"

        view.render([element], { "a" => "1234567890"})
        dump_view(view).should eq ["          ",
                                   "          ",
                                   "1234567890",
                                   "          ",
                                   "          "].join("\n")
      end

    end
  end
end
