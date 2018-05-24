require "./element_event_interface"
require "./extended_string"

module Hydra
  class Element

    KLASSES = {
      "prompt" => Hydra::Prompt,
      "logbox" => Hydra::Logbox,
      "text"  => Hydra::Text,
      "list" => Hydra::List,
    }

    getter :id
    getter :visible
    property :position
    @position : String
    property :event_interface
    @event_interface : ElementEventInterface | Nil
    property :template, :value

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(id : String, options = Hash(Symbol, String).new)
      instance = new(id, options)
      instance.event_interface = ElementEventInterface.new(instance)
      instance
    end

    def self.build(specs : Hash(Symbol, String)) : Element
      id = specs.delete(:id)
      raise "Element is missing an id: #{specs}" unless id
      type = specs.delete(:type)
      raise "Element is missing a type: #{specs}" unless type
      klass = KLASSES[type]
      element = klass.build(id, specs)
      element.position = specs[:position] if specs[:position]?
      element.hide if specs[:visible]? && specs[:visible] == "false"
      element
    end

    def initialize(id : String, options = Hash(Symbol, String).new)
      @id = id
      @visible = true
      @position = "0:0"
      @value = options[:value]? ? options[:value] : ""
      @template = options[:template]? ? options[:template] : ""
      @label = options[:label]? ? options[:label] : ""
    end

    def content() Hydra::ExtendedString
      Hydra::ExtendedString.new("Content for #{self.class.name} is undefined")
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

    def move(x : Int32, y : Int32)
      x1, y1 = @position.split(":").map(&.to_i)
      @position = "#{x1 + x}:#{y1 + y}"
    end

    def append(string : String)
    end

    def remove_last
    end

    def can_scroll_up?
      false
    end

    def scroll(x : Int32)
    end

    def can_scroll_down?
      false
    end

    def can_select_up?
      false
    end

    def can_select_down?
      false
    end

    def select_up
    end

    def select_down
    end

    def add_item(item : String)
    end

    def add_message(x : String)
    end

    def clear
    end
  end
end
