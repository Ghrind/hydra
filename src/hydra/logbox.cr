require "./element"

module Hydra
  class Logbox < Element
    def initialize(id : String, options = Hash(Symbol, String).new)
      super
      @width = options[:width]? ? options[:width].to_i : 50
      @height = options[:height]? ? options[:height].to_i : 10
      @messages = Array(ExtendedString).new
      @scroll_index = 0
    end

    def content() Hydra::ExtendedString
      a = 0
      if @messages.size > inner_height
        a = @messages.size - inner_height - @scroll_index
      end
      res = add_box(@messages[a..@messages.size - 1 - @scroll_index])
      Hydra::ExtendedString.new(res)
    end

    def add_message(message)
      @messages << ExtendedString.new(message)
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
      res = "┌" + "─" + @label.ljust(@width - 3, '─') + (can_scroll_up? ? "↑" : "┐") + "\n"
      content.each do |item|
        pad = item.string.size - item.stripped.size
        res += "│" + item.string.ljust(@width - 2 + pad) + "│\n"
      end
      (inner_height - content.size).times do
        res += "│" + "".ljust(@width - 2) + "│\n"
      end
      res += "└" + "─" * (@width - 2) + (can_scroll_down? ? "↓" : "┘")
      res
    end

    def trigger(behavior : String, payload = Hash(Symbol, String).new)
      case behavior
      when "scroll_up"
        scroll(1) if can_scroll_up?
      when "scroll_down"
        scroll(-1) if can_scroll_down?
      when "add_message"
        add_message payload["message"].to_s
      end
    end
  end
end
