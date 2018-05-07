require "crt"
require "./grid"
require "./cell"

module Hydra
  class Screen
    def initialize(x : Int32, y : Int32)
      @win = Crt::Window.new(x, y)
    end

    def update(grid : Grid(Cell))
      @win.clear
      grid.each do |cell, x, y|
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
