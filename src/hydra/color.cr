module Hydra
  class Color
    COLORS = {
      "white" => 7,
      "black" => 0,
      "red"   => 1,
      "green" => 2,
      "blue"  => 4,
    }

    getter :index

    def initialize(color_name : String)
      @name = color_name
      @index = 0
      if COLORS[color_name]?
        @index = COLORS[color_name]
      end
    end
  end
end
