require "crt"
require "./grid"
require "./cell"

module Hydra
  class Screen
    def initialize(x : Int32, y : Int32)
      Crt.init
      Crt.start_color
      @win = Crt::Window.new(x, y)
      @color_pairs = Hash(String, Crt::ColorPair).new
      init_colors
    end

    def update(grid : Grid(Cell))
      @win.clear
      grid.each do |cell, x, y|
        cell_color = "default"
        bold = false
        cell.tags.each do |tag|
          color = color_from_tag(tag)
          if color
            cell_color = color
          elsif tag == "bold"
            bold = true
          end
        end
        if bold
          @win.attribute_on(Crt::Attribute::Bold)
        else
          @win.attribute_off(Crt::Attribute::Bold)
        end
        @win.attribute_on(@color_pairs[cell_color])
        @win.print(x, y, cell.char)
      end
      @win.refresh
    end

    def getch
      @win.getch
    end

    def close
      Crt.done
    end

    def color_from_tag(tag : String) String
      if md = tag.match(/\A(#{@color_pairs.keys.join("|")})-fg\Z/)
        return md[1]
      end
      nil
    end

    private def init_colors
      @color_pairs = {
        "default" => Crt::ColorPair.new(Crt::Color::White, Crt::Color::Black),
        "red" => Crt::ColorPair.new(Crt::Color::Red, Crt::Color::Black),
        "blue" => Crt::ColorPair.new(Crt::Color::Blue, Crt::Color::Black),
        "green" => Crt::ColorPair.new(Crt::Color::Green, Crt::Color::Black)
      }
    end
  end
end
