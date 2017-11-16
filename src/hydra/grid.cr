module Hydra
  class Grid
    def initialize(x : Int32, y : Int32)
      @x = x
      @y = y
      @map = Array(Array(String)).new
      clear
    end

    def clear
      map = Array(Array(String)).new
      @x.times do |i|
        map << Array(String).new
        @y.times do
          map[i] << " "
        end
      end
      @map = map
    end

    def [](x : Int32, y : Int32) : String | Nil
      return "" unless @map[x]?
      return "" unless @map[x][y]?
      @map[x][y]
    end

    def []=(x : Int32, y : Int32, value : String)
      @map[x][y] = value
    end

    def dump
      @map.map { |row| row.join("") }.join("\n")
    end

    def each(&block)
      @map.each_with_index do |row, x|
        row.each_with_index do |char, y|
          yield char, x, y
        end
      end
    end
  end
end
