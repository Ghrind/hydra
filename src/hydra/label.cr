module Hydra
  class Label < Element
    def initialize(id : String)
      super
      @text = ""
    end

    def content
      box_content(@text)
    end

    def width
      @text.size + 2
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
