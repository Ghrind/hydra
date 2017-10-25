module Hydra
  class EventHub
    # Unused for now
    #CHARS_TO_EVENTS = {
    #  338 => "keypress.page_down",
    #  339 => "keypress.page_up",
    #  99  => "keypress.c",
    #  113 => "keypress.q",
    #  115 => "keypress.s",
    #  13  => "keypress.enter"
    #}

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

    def bind(event : String, target : String,  &block : EventHub, Event -> Bool)
      @bindings[event] = Array(Binding).new unless @bindings.has_key?(event)
      @bindings[event] << Binding.new(target, block)
    end

    def broadcast(event : Event)
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
          return unless binding.proc.call(self, event)
        else
          trigger(binding.target, binding.behavior, binding.params.merge({:event => event.name}))
        end
      end
    end

    def trigger(target : String, behavior : String, params = Hash(Symbol, String).new)
      return Array(String).new unless @register[target]?
      events = @register[target].trigger(behavior, params)
      events.each do |event|
        broadcast Event.new(event)
      end
    end
  end
end
