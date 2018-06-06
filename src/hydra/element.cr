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
    property :template, :value

    def self.build(specs : Hash(Symbol, String)) : Element
      id = specs.delete(:id)
      raise "Element is missing an id: #{specs}" unless id
      type = specs.delete(:type)
      raise "Element is missing a type: #{specs}" unless type
      klass = KLASSES[type]
      element = klass.new(id, specs)
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

    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      if behavior == "show"
        show
      elsif behavior == "hide"
        hide
      end
    end

    def on_register(event_hub : EventHub)
    end
  end
end
