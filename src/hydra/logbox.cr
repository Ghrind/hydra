module Hydra
  class LogboxEventInterface < ElementEventInterface
    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      case behavior
      when "scroll_up"
        @target.scroll(1) if @target.can_scroll_up?
      when "scroll_down"
        @target.scroll(-1) if @target.can_scroll_down?
      when "add_message"
        @target.add_message payload["message"].to_s
      end
    end
  end
  class Logbox < Element
    getter :width
    getter :height

    # Workaround for the inability to use self in an initializer
    # https://github.com/crystal-lang/crystal/issues/4436
    def self.build(id : String, options = Hash(Symbol, String).new)
      instance = new(id)
      instance.event_interface = LogboxEventInterface.new(instance)
      instance
    end

    def initialize(id : String)
      super
      @width = 50
      @height = 10
      @messages = Array(String).new
      @scroll_index = 0
    end

    def content
      a = 0
      if @messages.size > inner_height
        a = @messages.size - inner_height - @scroll_index
      end
      add_box(@messages[a..@messages.size - 1 - @scroll_index])
    end

    def add_message(message)
      @messages << message
    end

    def scroll(value : Int32)
      @scroll_index += value
    end

    def name
      "logbox"
    end

    def max_scroll_index
      @messages.size - inner_height
    end

    def can_scroll_up?() Bool
      return false unless @messages.size > inner_height
      @scroll_index < max_scroll_index
    end

    def can_scroll_down?() Bool
      return false unless @messages.size > inner_height
      @scroll_index > 0
    end

    def inner_height() Int32
      @height - 2 # 2 borders
    end

    def add_box(content)
      res = "┌" + "─" * (@width - 2) + (can_scroll_up? ? "↑" : "┐") + "\n"
      content.each do |item|
        res += "│" + item.ljust(@width - 2) + "│\n"
      end
      (inner_height - content.size).times do
        res += "│" + "".ljust(@width - 2) + "│\n"
      end
      res += "└" + "─" * (@width - 2) + (can_scroll_down? ? "↓" : "┘")
      res
    end
  end
end
