module Hydra
  class EventInterface
    def trigger(behavior : String, payload = Hash(Symbol, String).new)
    end

    def on_register(event_hub : Hydra::EventHub)
    end
  end
end
