require "crt"

module Hydra
  class View
    def initialize(x = 20, y = 60)
      @win = Crt::Window.new(x, y)
    end

    def close
      Crt.done
    end

    def getch()
      @win.getch
    end

    def render(elements : ElementCollection)
      @win.clear
      elements.each do |el|
        render_element(el) if el.visible
      end
      @win.refresh
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
