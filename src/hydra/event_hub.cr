require "./binding"

module Hydra
  class EventHub

    def self.char_to_event(char : Int32) String
      return "keypress.##{char}" unless CHARS_TO_EVENTS.has_key?(char)
      CHARS_TO_EVENTS[char]
    end

    def initialize
      @register = {} of String => EventInterface
      @bindings = {} of String => Array(Binding)
      @focus = ""
    end

    def register(key : String, event_interface : EventInterface)
      raise "Id already registered" if @register[key]?
      @register[key] = event_interface
      event_interface.on_register(self)
    end

    def focus(identifier : String)
      @focus = identifier
    end

    def unfocus()
      @focus = ""
    end

    def has_focus?(identifier : String) : Bool
      @focus == identifier
    end

    def bind(event : String, target : String, behavior : String)
      @bindings[event] = Array(Binding).new unless @bindings.has_key?(event)
      @bindings[event] << Binding.new(target, behavior)
    end

    def bind(event : String, target : String,  &block : EventHub, Event, ElementCollection, State -> Bool)
      @bindings[event] = Array(Binding).new unless @bindings.has_key?(event)
      @bindings[event] << Binding.new(target, block)
    end

    def broadcast(event : Event, state : State, elements : ElementCollection)
      # TODO: Ugly
      parts = event.name.split(".")
      parts.pop
      parts << "*"
      other_name = parts.join(".")

      bindings = Array(Binding).new
      bindings += @bindings[event.name] if @bindings[event.name]?
      bindings += @bindings[other_name] if @bindings[other_name]?

      bindings.sort { |a, b| (a.target == @focus ? 0 : 1) <=> (b.target == @focus ? 0 : 1)}.each do |binding|
        if binding.behavior == ""
          return unless binding.proc.call(self, event, elements, state)
        else
          trigger(binding.target, binding.behavior, binding.params.merge({:event => event.name}))
        end
      end
    end

    def trigger(target : String, behavior : String, params = Hash(Symbol, String).new)
      return unless @register[target]?
      @register[target].trigger(behavior, params)
    end
  end
end
