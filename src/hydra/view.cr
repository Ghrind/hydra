require "./view_crt_interface"
require "./view_test_interface"
require "./element"
require "./element_collection"

module Hydra
  class View
    @interface : ViewInterface

    def initialize(x = 20, y = 60)
      @x = x
      @y = y
      @interface = ViewCrtInterface.new(x, y)
    end

    def initialize(interface_type : typeof(Hydra::ViewInterface), x = 20, y = 60)
      @x = x
      @y = y
      @interface = interface_type.new(x, y)
    end

    def close
      @interface.close
    end

    def closed?
      @interface.closed?
    end

    def getch
      @interface.getch
    end

    def dump
      @interface.dump
    end

    def render(elements : Array(Element), state = Hash(String, String).new)
      @interface.clear
      elements.each do |el|
        if el.template != ""
          el.value = el.template
          state.each do |key, value|
            el.value = el.value.sub("{{#{key}}}", value)
          end
        end
        render_element(el) if el.visible
      end
      @interface.commit
    end

    def render_element(element : Element)
      x, y = 0, 0
      if element.position == "center"
        x = (@x.to_f / 2 - element.height.to_f / 2).floor.to_i
        y = (@y.to_f / 2 - element.width.to_f / 2).floor.to_i
      else
        x, y = element.position.split(":").map(&.to_i)
      end

      i = 0
      element.content.each_line do |l|
        @interface.print(x + i, y, l)
        i += 1
      end
    end
  end
end
