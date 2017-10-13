module Hydra
  class EventHub
    CHARS_TO_EVENTS = {
      338 => "keypress.page_down",
      339 => "keypress.page_up",
      99  => "keypress.c"
    }

    def self.char_to_event(char : Int32) String
      return "keypress.unknown" unless CHARS_TO_EVENTS.has_key?(char)
      CHARS_TO_EVENTS[char]
    end

    def initialize
      @register = {} of String => EventInterface
      @bindings = {} of String => Array(Binding)
    end

    def register(key : String, event_interface : EventInterface)
      raise "Id already registered" if @register[key]?
      @register[key] = event_interface
    end

    def bind(event : String, target : String, behavior : String)
      @bindings[event] = Array(Binding).new unless @bindings.has_key?(event)
      @bindings[event] << Binding.new(target, behavior)
    end

    def broadcast(event : String)
      return unless @bindings.has_key?(event)
      @bindings[event].each do |binding|
        trigger(binding.target, binding.behavior, binding.params)
      end
    end

    def trigger(target : String, behavior : String, params : String)
      return unless @register[target]?
      @register[target].trigger(behavior, params)
    end
  end
end
