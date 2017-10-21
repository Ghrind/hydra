module Hydra
  class Binding
    getter :target
    getter :behavior
    getter :params
    getter :proc

    def initialize(target : String, behavior : String, params = Hash(Symbol, String).new)
      @target = target
      @behavior = behavior
      @params = params
      @proc = ->( x : EventHub, y : Event) { true }
    end

    def initialize(target : String, block : Proc(EventHub, Event, Bool))
      @target = target
      @behavior = ""
      @params = Hash(Symbol, String).new
      @proc = block
    end
  end
end
