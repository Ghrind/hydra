module Hydra
  class Label < Element
    def initialize(id : String, options = Hash(Symbol, String).new)
      super
    end

    def content
      box_content(@value)
    end

    def width
      @value.size + 2
    end

    def height
      3
    end

    private def box_content(content)
      res = "┌" + "─" * content.size + "┐\n"
      res += "│" + content + "│\n"
      res += "└" + "─" * content.size + "┘"
      res
    end
  end
end
