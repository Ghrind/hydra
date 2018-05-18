module Hydra
  class Screen
    def initialize
    end

    def getch() Keypress
      nil
    end

    def update(grid : Grid(Cell))
    end

    def close
    end

    def width
      0
    end

    def height
      0
    end
  end
end
