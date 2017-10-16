module Hydra
  class Binding
    getter :target
    getter :behavior
    getter :params

    def initialize(target : String, behavior : String, params = Hash(Symbol, String).new)
      @target = target
      @behavior = behavior
      @params = params
    end
  end
end
