module Hydra
  class PromptElementEventInterface < ElementEventInterface
    def initialize(target : Prompt)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String).new) : Array(String)
      if behavior == "submit"
        ["#{@target.id}.submit"]
      elsif behavior == "append"
        @target.append(payload[:char])
        Array(String).new
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
  end
end
