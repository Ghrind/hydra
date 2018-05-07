require "./element"

module Hydra
  class Text < Element
    def initialize(id : String, options = Hash(Symbol, String).new)
      super
    end

    def content() Hydra::ExtendedString
      Hydra::ExtendedString.new(box_content(@value))
    end

    def width
      (extended_value.stripped.split("\n") + [@label + "**"]).map { |s| s.size }.max + 2
    end

    def height
      extended_value.stripped.split("\n").size + 2
    end

    def extended_value
      Hydra::ExtendedString.new(@value)
    end

    private def box_content(content)
      x = width
      res = "┌" + "─" + @label.ljust(x - 3, '─') + "┐\n"
      content.split("\n").each do |line|
        extended_line = Hydra::ExtendedString.new(line)
        pad = line.size - extended_line.stripped.size
        res += "│" + line.ljust(x - 2 + pad, ' ') + "│\n"
      end
      res += "└" + "─" * (x - 2) + "┘"
      res
    end
  end
end
