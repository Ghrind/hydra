require "crt"

module Hydra
  class View
    def initialize(x = 20, y = 60)
      @win = Crt::Window.new(x, y)
      @elements = Array(Element).new
    end

    def close
      Crt.done
    end

    def getch()
      @win.getch
    end

    def render
      @win.clear
      @elements.each do |el|
        render_element(el) if el.visible
      end
      @win.refresh
    end

    def add_element(element)
      @elements << element
    end

    def element(id : String) : Element
      e = @elements.find { |e| e.id == id }
      raise "Element not found #{id}" unless e
      e
    end

    def render_element(element : Element)
      x, y = 0, 0
      if element.position == "center"
        x = @win.row / 2 - element.height / 2
        y = @win.col / 2 - element.width / 2
      else
        x, y = element.position.split(":").map(&.to_i)
      end

      i = 0
      element.content.each_line do |l|
        @win.print(x + i, y, l)
        i += 1
      end
    end
  end
end
