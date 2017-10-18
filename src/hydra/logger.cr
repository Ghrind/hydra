module Hydra
  class LoggerEventInterface < EventInterface
    def initialize(target : Hydra::Logger)
      @target = target
    end
    def trigger(behavior : String, payload : Hash(Symbol, String)) : Array(String)
      if behavior == "debug"
        @target.debug "#{payload}"
        Array(String).new
      else
        super
      end
    end
  end
  class Logger < ::Logger
    property :event_interface
    @event_interface : Hydra::LoggerEventInterface

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(io : IO?)
      instance = new(io)
      instance.event_interface = LoggerEventInterface.new(instance)
      instance
    end

    def initialize(io : IO?)
      super
      @event_interface = uninitialized LoggerEventInterface
    end
  end
end
