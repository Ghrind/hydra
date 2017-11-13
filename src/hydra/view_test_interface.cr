require "./view_interface"

module Hydra
  class ViewTestInterface < ViewInterface
    @canvas : Array(Array(String))
    def initialize(x : Int32, y : Int32)
      @x = x
      @y = y
      @canvas = Array(Array(String)).new
      clear
      super
    end

    def clear
      canvas = Array(Array(String)).new
      @x.times do |i|
        canvas << Array(String).new
        @y.times do
          canvas[i] << " "
        end
      end
      @canvas = canvas
    end

    def print(x : Int, y : Int, text : String)
      text.split("").each_with_index do |char, i|
        @canvas[x][y + i] = char
      end
    end

    def dump
      @canvas.map { |row| row.join("") }.join("\n")
    end
  end
end
