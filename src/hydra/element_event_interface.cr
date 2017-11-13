require "./event_interface"

module Hydra
  class ElementEventInterface < EventInterface
    def initialize(target : Element)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      if behavior == "show"
        @target.show
      elsif behavior == "hide"
        @target.hide
      else
        super
      end
    end
  end
end
