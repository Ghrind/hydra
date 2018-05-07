module Hydra
  class Grid(T)
    def initialize(x : Int32, y : Int32)
      @x = x
      @y = y
      @map = Array(Array(T)).new
      clear
    end

    def clear
      fill_with(T.new)
    end

    def [](x : Int32, y : Int32) : T | Nil
      return nil unless @map[x]?
      return nil unless @map[x][y]?
      @map[x][y]
    end

    def []=(x : Int32, y : Int32, value : T)
      @map[x][y] = value
    end

    def dump
      @map.map { |row| row.join("") }.join("\n")
    end

    def fill_with(item : T)
      map = Array(Array(T)).new
      @x.times do |i|
        map << Array(T).new
        @y.times do
          map[i] << item.dup
        end
      end
      @map = map
    end

    def lines
      @map
    end

    def each(&block)
      @map.each_with_index do |row, x|
        row.each_with_index do |item, y|
          yield item, x, y
        end
      end
    end
  end
end
