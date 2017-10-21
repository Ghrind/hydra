module Hydra
  class EventInterface
    def trigger(behavior : String, payload = Hash(Symbol, String).new) : Array(String)
      Array(String).new
    end
  end
end
