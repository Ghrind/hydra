module Hydra
  class Binding
    getter :target
    getter :behavior
    getter :params
    getter :proc
    getter :focus

    def initialize(target : String, behavior : String, blocking : Bool, focus : String, params = Hash(Symbol, String).new)
      @focus = focus
      @blocking = blocking
      @target = target
      @behavior = behavior
      @params = params
      @proc = ->( x : EventHub, y : Event, a : ElementCollection, z : State) { true }
    end

   #def initialize(target : String, behavior : String, params = Hash(Symbol, String).new)
   #  @focus = nil
   #  @blocking = false
   #  @target = target
   #  @behavior = behavior
   #  @params = params
   #  @proc = ->( x : EventHub, y : Event, a : ElementCollection, z : State) { true }
   #end

    def initialize(focus : String, block : Proc(EventHub, Event, ElementCollection, State, Bool))
      @focus = focus
      @blocking = false # blocking is not used when there is a block, it is determined by the return value of the block
      @target = ""
      @behavior = ""
      @params = Hash(Symbol, String).new
      @proc = block
    end

    def initialize(block : Proc(EventHub, Event, ElementCollection, State, Bool))
      @focus = nil
      @blocking = false # blocking is not used when there is a block, it is determined by the return value of the block
      @target = ""
      @behavior = ""
      @params = Hash(Symbol, String).new
      @proc = block
    end

   #def initialize(target : String, block : Proc(EventHub, Event, ElementCollection, State, Bool))
   #  @focus = nil
   #  @blocking = false
   #  @target = target
   #  @behavior = ""
   #  @params = Hash(Symbol, String).new
   #  @proc = block
   #end

    def blocking?() Bool
      @blocking
    end
  end
end
