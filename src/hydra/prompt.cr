require "./element"

module Hydra
  class Prompt < Element
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

    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      if behavior == "append"
        append(payload[:char])
      elsif behavior == "remove_last"
        remove_last
      elsif behavior == "clear"
        clear
      else
        super
      end
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind(id, "keypress.*") do |eh, event|
        keypress = event.keypress
        if keypress
          if keypress.char != ""
            eh.trigger(id, "append", { :char => keypress.char })
            false
          elsif keypress.name == "backspace"
            eh.trigger(id, "remove_last")
            false
          else
            true
          end
        else
          true
        end
      end
    end
  end
end
