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
end
