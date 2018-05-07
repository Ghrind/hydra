require "./element"
require "./prompt_element_event_interface"

module Hydra
  class Prompt < Element
    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(id : String, options = Hash(Symbol, String).new)
      instance = new(id, options)
      instance.event_interface = PromptElementEventInterface.new(instance)
      instance
    end

    def content() Hydra::ExtendedString
      ExtendedString.new(box_content(@value))
    end

    private def box_content(content)
      if content.size > (width - 2)
        content = "…" + content[-(width - 3)..-1]
      end
      top_bar = "─" + @label.ljust(width - 3, '─')
      res = "┌" + top_bar + "┐\n"
      res += "│" + ExtendedString.escape(content.ljust(width - 2)) + "│\n"
      res += "└" + "─" * (width - 2) + "┘"
      res
    end

    def append(string : String)
      @value += string
    end

    def width
      30
    end

    def height
      3
    end

    def remove_last
      return if @value.size == 0
      @value = @value[0..-2]
    end

    def value
      @value
    end

    def clear
      @value = ""
    end
  end
end
