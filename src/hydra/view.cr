require "./grid"
require "./cell"
require "./element"
require "./filter"
require "./border_filter"

module Hydra
  class View
    property :filters
    getter :x, :y, :grid
    def initialize(x = 20, y = 60)
      @x = x
      @y = y
      @grid = Grid(Hydra::Cell).new(x, y)
      @filters = Array(Filter.class).new
    end

    def clear
      @grid = Grid(Hydra::Cell).new(@x, @y)
    end

    def print(x : Int, y : Int, text : String, tags : Array(String))
      text.split("").each_with_index do |char, i|
        cell = Hydra::Cell.new(char, tags)
        @grid[x, y + i] = cell
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
      @filters.reduce(@grid) do |memo, filter|
        filter.apply(memo)
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
      j = 0

      element.content.chunks.each do |chunk|
        lines = chunk.string.split("\n")
        lines.each_with_index do |l, idx|
          if idx > 0
            i += 1
            j = 0
          end
          print(x + i, y + j, l, chunk.tags)
          j += l.size
        end
      end
    end
  end
end
