require "./event_interface"
module Hydra
  class ElementEventInterface < EventInterface
    def initialize(target : Element)
      @target = target
    end
    def trigger(behavior : String, payload = Hash(Symbol, String)) : Array(String)
      if behavior == "show"
        @target.show
        Array(String).new
      else
        super
      end
    end
  end
  class Element

    getter :id
    getter :visible
    property :event_interface
    @event_interface : ElementEventInterface

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(id : String)
      instance = new(id)
      instance.event_interface = ElementEventInterface.new(instance)
      instance
    end

    def initialize(id : String)
      @id = id
      @event_interface = uninitialized ElementEventInterface
      @visible = true
    end

    def content
      "Content undefined for #{self.class.name}"
    end

    def width
      0
    end

    def height
      0
    end

    def show
      @visible = true
    end

    def hide
      @visible = false
    end
  end
end
