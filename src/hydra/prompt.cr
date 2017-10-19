module Hydra
  class PromptElementEventInterface < ElementEventInterface
    def initialize(target : Element)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String)) : Array(String)
      if behavior == "submit"
        ["#{@target.id}.submit"]
      else
        super
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
  end
end
