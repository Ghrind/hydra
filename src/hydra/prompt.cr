module Hydra
  class PromptElementEventInterface < ElementEventInterface
    def trigger(behavior : String, payload = Hash(Symbol, String).new) : Array(String)
      if behavior == "submit"
        return ["#{@target.id}.submit"]
      elsif behavior == "append"
        @target.append(payload[:char])
      elsif behavior == "remove_last"
        @target.remove_last
      else
        return super
      end
      Array(String).new
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
          elsif keypress.name == "enter"
            eh.trigger(@target.id, "submit")
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
      %("#{@value}")
    end

    def append(string : String)
      @value += string
    end

    def remove_last
      return if @value.size == 0
      @value = @value[0..-2]
    end
  end
end
