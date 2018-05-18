require "./screen"
require "termbox"
require "./grid"
require "./cell"
require "./color"

module Hydra
  class TerminalScreen < Screen
    def initialize(width : Int32, height : Int32)
      super
      @win = Termbox::Window.new#(x, y)

      # Use 256 color mode
      @win.set_output_mode(Termbox::OUTPUT_256)

      @foreground_color = Color.new("white")
      @background_color = Color.new("black")
      @win.set_primary_colors(@foreground_color.index, @background_color.index)
    end

    def update(grid : Grid(Cell))
      @win.clear
      grid.each do |cell, x, y|
        foreground_color = @foreground_color
        background_color = @background_color
        cell.tags.each do |tag|
          color = color_from_tag(tag)
          if color
            foreground_color = color
          end
        end
        @win.write_string(Termbox::Position.new(y, x), cell.char, foreground_color.index, background_color.index)
      end
      @win.render
    end

    def getch() Keypress
      event = @win.peek(1)
      if event.type == Termbox::EVENT_KEY
        if event.ch > 0
          Keypress.new(event.ch)
        elsif event.key > 0
          Keypress.new(UInt32.new(event.key))
        end
      else
        return nil
      end
    end

    def close
      @win.shutdown
    end

    def color_from_tag(tag : String) String
      if md = tag.match(/\A(#{Color::COLORS.keys.join("|")})-fg\Z/)
        return Color.new(md[1])
      end
      nil
    end
  end
end
