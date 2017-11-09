module Hydra
  class PromptElementEventInterface < ElementEventInterface
    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      if behavior == "append"
        @target.append(payload[:char])
      elsif behavior == "remove_last"
        @target.remove_last
      elsif behavior == "clear"
        @target.clear
      else
        super
      end
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind("keypress.*", @target.id) do |eh, event|
        keypress = event.keypress
        if eh.has_focus?(@target.id) && keypress
          if keypress.char != ""
            eh.trigger(@target.id, "append", { :char => keypress.char })
            false
          elsif keypress.name == "backspace"
            eh.trigger(@target.id, "remove_last")
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
  class Prompt < Element
    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(id : String)
      instance = new(id)
      instance.event_interface = PromptElementEventInterface.new(instance)
      instance
    end

    def initialize(id : String)
      super
      @value = ""
    end

    def content
      box_content(@value)
    end

    private def box_content(content)
      res = "┌" + "─" * (width - 2) + "┐\n"
      res += "│" + content.ljust(width - 2) + "│\n"
      res += "└" + "─" * (width - 2) + "┘"
      res
    end

    def append(string : String)
      @value += string
    end

    def width
      30
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
