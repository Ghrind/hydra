require "./element"

module Hydra
  class Label < Element
    def initialize(id : String, options = Hash(Symbol, String).new)
      super
    end

    def content
      box_content(@value)
    end

    def width
      @value.split("\n").map { |s| s.size }.max + 2
    end

    def height
      @value.split("\n").size + 2
    end

    private def box_content(content)
      x = width
      res = "┌" + "─" * (x - 2) + "┐\n"
      content.split("\n").each do |row|
        res += "│" + row.ljust(x - 2, ' ') + "│\n"
      end
      res += "└" + "─" * (x - 2) + "┘"
      res
    end
  end
end
