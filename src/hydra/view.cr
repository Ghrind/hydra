require "./grid"
require "./element"
require "./filter"
require "./border_filter"

module Hydra
  class View
    property :filters
    getter :x, :y
    def initialize(x = 20, y = 60)
      @x = x
      @y = y
      @grid = Grid.new(x, y)
      @filters = Array(Filter.class).new
    end

    def dump
      @filters.reduce(@grid) do |memo, filter|
        filter.apply(memo)
      end.dump
    end

    def clear
      @grid = Grid.new(@x, @y)
    end

    def print(x : Int, y : Int, text : String)
      text.split("").each_with_index do |char, i|
        @grid[x, y + i] = char
      end
    end

    def render(elements : Array(Element), state = Hash(String, String).new)
      clear
      elements.each do |el|
        if el.template != ""
          el.value = el.template
          state.each do |key, value|
            el.value = el.value.sub("{{#{key}}}", value)
          end
        end
        render_element(el) if el.visible
      end
    end

    def render_element(element : Element)
      x, y = 0, 0
      if element.position == "center"
        x = (@x.to_f / 2 - element.height.to_f / 2).floor.to_i
        y = (@y.to_f / 2 - element.width.to_f / 2).floor.to_i
      else
        x, y = element.position.split(":").map(&.to_i)
      end

      i = 0
      element.content.each_line do |l|
        print(x + i, y, l)
        i += 1
      end
    end
  end
end
