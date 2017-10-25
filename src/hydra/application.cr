require "./event_interface"
module Hydra
  class ApplicationEventInterface < EventInterface
    def initialize(target : Application)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String)) : Array(String)
      if behavior == "stop"
        @target.stop
        Array(String).new
      else
        super
      end
    end
  end
  class Application
    property :event_interface
    @event_interface : ApplicationEventInterface

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(view : Hydra::View, event_hub : Hydra::EventHub)
      instance = new(view, event_hub)
      instance.event_interface = ApplicationEventInterface.new(instance)
      instance
    end

    def self.setup() : Hydra::Application
      event_hub = Hydra::EventHub.new
      view = Hydra::View.new(x: 50, y: 100)
      instance = build(view, event_hub)
      event_hub.register("application", instance.event_interface)
      instance
    end

    def initialize(view : Hydra::View, event_hub : Hydra::EventHub)
      @view = view
      @event_interface = uninitialized ApplicationEventInterface
      @event_hub = event_hub
      @logger = Logger.new(File.open("./debug.log", "w"))
      @logger.level = Logger::DEBUG
    end

    def start
      @view.render
      @running = true
      while @running
        char = @view.getch
        sleep 0.01
        next unless char >= 0
        @logger.debug "#{char}: #{char.chr}"
        keypress = Keypress.new(char)
        event = Event.new("keypress.#{keypress.name}")
        event.keypress = keypress
        @event_hub.broadcast(event)
        @view.render
      end
      @view.close
    end

    def stop
      @running = false
    end

    def bind(event : String, target : String, behavior : String)
      @event_hub.bind(event, target, behavior)
    end

    def bind(event : String, target : String,  &block : EventHub, Event -> Bool)
      @event_hub.bind(event, target, &block)
    end

    def add_element(element : Element)
      @view.add_element(element)
      @event_hub.register(element.id, element.event_interface)
    end

    def add_element(specs : Hash(Symbol, String))
      element = Element.build(specs)
      add_element(element)
    end

  end
end
