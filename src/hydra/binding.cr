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
      @proc = ->( x : EventHub) {}
    end

    def initialize(block : Proc(EventHub, Nil))
      @target = ""
      @behavior = ""
      @params = Hash(Symbol, String).new
      @proc = block
    end
  end
end
