module Hydra
  class EventHub
    CHARS_TO_EVENTS = {
      338 => "keypress.page_down",
      339 => "keypress.page_up",
      99  => "keypress.c"
    }

    def self.char_to_event(char : Int32) String
      LOGGER.debug("Key pressed charcode: #{char}")
      return "keypress.unknown" unless CHARS_TO_EVENTS.has_key?(char)
      CHARS_TO_EVENTS[char]
    end

    def initialize(view : View, socket : Socket)
      @view = view
      @socket = socket
      @bindings = {} of String => Array(Binding)
    end

    def bind(event : String, target : String, behavior : String)
      @bindings[event] = Array(Binding).new unless @bindings.has_key?(event)
      @bindings[event] << Binding.new(target, behavior)
    end

    def broadcast(event : String)
      return unless @bindings.has_key?(event)
      @bindings[event].each do |binding|
        if binding.target == "client"
          @socket.puts binding.behavior
        else
          trigger(binding.target, binding.behavior, binding.params)
        end
      end
    end

    def trigger(target : String, behavior : String, params : String)
      element = @view.element(target)
      element.do(behavior, params) if element
    end
  end
end
