module Hydra
  class Screen
    def initialize(height : Int32, width : Int32)
      @height = height
      @width = width
    end

    def getch() Keypress
      nil
    end

    def update(grid : Grid(Cell))
    end

    def close
    end
  end
end
