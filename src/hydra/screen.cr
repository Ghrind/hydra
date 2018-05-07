require "crt"
require "./grid"
require "./cell"

module Hydra
  class Screen
    def initialize(x : Int32, y : Int32)
      Crt.init
      Crt.start_color
      @win = Crt::Window.new(x, y)
      @red = Crt::ColorPair.new(Crt::Color::Red, Crt::Color::Black)
      @default = Crt::ColorPair.new(Crt::Color::White, Crt::Color::Black)
    end

    def update(grid : Grid(Cell))
      @win.clear
      grid.each do |cell, x, y|
        if cell.tags.includes?("red-fg")
          @win.attribute_on(@red)
        else
          @win.attribute_on(@default)
        end
        @win.print(x, y, cell.char)
      end
      @win.refresh
    end

    def getch
      @win.getch
    end

    def close
      Crt.done
    end
  end
end
