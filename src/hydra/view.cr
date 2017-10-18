require "crt"

module Hydra
  class View
    property :event_interface
    @event_interface : EventInterface
    def initialize(x = 20, y = 60)
      @win = Crt::Window.new(x, y)
      @elements = Array(Element).new
      @event_interface = EventInterface.new
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

    def element(name) : Element
      @elements.find { |e| e.name == name }
    end

    def render_element(element : Element)
      x = @win.row / 2 - element.height / 2
      y = @win.col / 2 - element.width / 2

      i = 0
      element.content.each_line do |l|
        @win.print(x + i, y, l)
        i += 1
      end
    end
  end
end
