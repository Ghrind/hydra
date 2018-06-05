require "./element_collection"
require "./event"
require "./event_hub"
require "./event_interface"
require "logger"
require "./screen"
require "./terminal_screen"
require "./view"
require "./state"

module Hydra
  class ApplicationEventInterface < EventInterface
    def initialize(target : Application)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String))
      if behavior == "stop"
        @target.stop
      else
        super
      end
    end
  end
  class Application
    property :event_interface
    @event_interface : ApplicationEventInterface

    getter :logger

    # Creates a new application with injected dependencies and sensible defaults
    def self.setup(event_hub : EventHub | Nil = nil,
                   view : View | Nil  = nil,
                   logger : Logger | Nil = nil,
                   screen : Screen | Nil = nil,
                   elements : ElementCollection | Nil = nil,
                   state : State | Nil = nil) : Hydra::Application

      event_hub = Hydra::EventHub.new unless event_hub

      unless logger
        logger = Logger.new(File.open("./debug.log", "w"))
        logger.level = Logger::DEBUG
      end

      screen = TerminalScreen.new unless screen

      unless view
        view = Hydra::View.new(height: screen.height, width: screen.width)
        view.filters << BorderFilter
      end

      elements = ElementCollection.new unless elements

      state = State.new unless state

      instance = build(view: view, event_hub: event_hub, logger: logger, screen: screen, state: state, elements: elements)
      event_hub.register("application", instance.event_interface)

      instance
    end

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(**params)
      instance = new(**params)
      instance.event_interface = ApplicationEventInterface.new(instance)
      instance
    end

    private def initialize(view : Hydra::View, event_hub : Hydra::EventHub, logger : Logger, screen  : Screen, elements : ElementCollection, state : State)
      @screen = screen
      @view = view
      @logger = logger
      @event_interface = uninitialized ApplicationEventInterface
      @event_hub = event_hub
      @elements = elements
      @state = state
    end

    def run
      @running = true
      @event_hub.broadcast(Event.new("ready"), @state, @elements)
      update_screen
      while @running
        sleep 0.01
        handle_keypress @screen.getch
      end
    end

    private def handle_keypress(keypress : Keypress | Nil)
      return unless keypress
      event = Event.new(keypress)
      @event_hub.broadcast(event, @state, @elements)
      update_screen
    end

    def teardown
      @screen.close
    end

    def stop
      @running = false
    end

    private def update_screen
      @view.render(@elements.to_a, @state)
      @screen.update(@view.grid)
    end

    def bind(focus : String, event : String, target : String, behavior : String)
      @event_hub.bind(focus, event, target, behavior)
    end

    def bind(event : String, target : String, behavior : String)
      @event_hub.bind(event, target, behavior)
    end

    def bind(focus : String, event : String,  &block : EventHub, Event, ElementCollection, State -> Bool)
      @event_hub.bind(focus, event, &block)
    end

    def bind(event : String,  &block : EventHub, Event, ElementCollection, State -> Bool)
      @event_hub.bind(event, &block)
    end

    def add_element(element : Element)
      @elements.push(element)
      event_interface = element.event_interface
      return unless event_interface
      @event_hub.register(element.id, event_interface)
    end

    def add_element(specs : Hash(Symbol, String))
      element = Element.build(specs)
      add_element(element)
    end

  end
end
