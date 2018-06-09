require "./element"

module Hydra
  class List < Element
    getter :selected

    NONE_SELECTED = -1

    def initialize(id : String, options = Hash(Symbol, String).new)
      super
      @width = options[:width]? ? options[:width].to_i : 50
      @height = options[:height]? ? options[:height].to_i : 10
      @items = Array(ExtendedString).new
      @scroll_index = 0
      @selected = NONE_SELECTED
    end

    def content() Hydra::ExtendedString
      lower_bound = @scroll_index * -1
      upper_bound = lower_bound + inner_height - 1
      items = Array(ExtendedString).new
      @items[lower_bound..upper_bound].each_with_index do |item, index|
        if index - @scroll_index == @selected
          item = ExtendedString.new("<inverted>#{item.string}</inverted>")
        end
        items << item
      end
      res = add_box(items)
      Hydra::ExtendedString.new(res)
    end

    def add_item(item)
      @items << ExtendedString.new(item)
      if @items.size == 1
        select_first
      end
    end

    def select_first
      @selected = 0
    end

    def change_item(index, item)
      if @items[index]?
        @items[index] = ExtendedString.new(item)
      end
    end

    def scroll(value : Int32)
      @scroll_index += value
    end

    def name
      # TODO: What is this?
      "logbox"
    end

    def clear
      @items.clear
    end

    def select_item(index : Int32)
      @selected = index
    end

   def value() String
     return "" if none_selected?
     @items[@selected].string
   end

    def none_selected?() Bool
      @selected == NONE_SELECTED
    end

    def min_scroll_index
      inner_height - @items.size
    end

    def can_select_up?() Bool
      @selected > 0
    end

    def can_select_down?() Bool
      @selected < @items.size - 1
    end

    def select_down
      select_item(@selected + 1)
      scroll(-1) if can_scroll_down?
    end

    def select_up
      select_item(@selected - 1)
      scroll(1) if can_scroll_up?
    end

    def can_scroll_up?() Bool
      return false if @items.size <= inner_height
      @scroll_index < 0
    end

    def can_scroll_down?() Bool
      return false if @items.size <= inner_height
      @scroll_index > min_scroll_index
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
      when "select_up"
        select_up if can_select_up?
      when "select_down"
        select_down if can_select_down?
      when "add_item"
        add_item payload["item"].to_s
      when "change_item"
        change_item payload["index"].to_i, payload["item"]
      else
        super
      end
    end
  end
end
