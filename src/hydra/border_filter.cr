require "./filter"
module Hydra
  class BorderFilter < Filter
    def self.apply(grid : Grid(Cell)) : Grid(Cell)
      new(grid).apply
    end

    def initialize(grid : Grid(Cell))
      @grid = grid
    end

    def apply() : Grid
      @grid.each do |cell, x, y|
        char = cell.char
        char = connect_up(char) if connect_char_up?(x, y)
        char = connect_down(char) if connect_char_down?(x, y)
        char = connect_left(char) if connect_char_left?(x, y)
        char = connect_right(char) if connect_char_right?(x, y)
        cell.char = char
        @grid[x, y] = cell
      end
      @grid
    end

    def connect_char_up?(x : Int32, y : Int32) : Bool
      cell = @grid.[x - 1, y]
      return false unless cell
      ["│", "┐", "┬", "┌", "┤", "├", "┼"].includes?(cell.char)
    end

    def connect_up(char : String) : String
      case char
      when "┌"
        "├"
      when "┬"
        "┼"
      when "┐"
        "┤"
      when "─"
        "┴"
      else
        char
      end
    end

    def connect_char_down?(x : Int32, y : Int32) : Bool
      cell = @grid.[x + 1, y]
      return false unless cell
      ["│", "└", "┴", "┘", "┤", "├", "┼"].includes?(cell.char)
    end

    def connect_down(char : String) : String
      case char
      when "└"
        "├"
      when "┴"
        "┼"
      when "┘"
        "┤"
      when "─"
        "┬"
      else
        char
      end
    end

    def connect_char_left?(x : Int32, y : Int32) : Bool
      cell = @grid.[x, y - 1]
      return false unless cell
      ["┌", "┬", "├", "┼", "└", "┴", "─"].includes?(cell.char)
    end

    def connect_left(char : String) : String
      case char
      when "└"
        "┴"
      when "┌"
        "┬"
      when "├"
        "┼"
      when "│"
        "┤"
      else
        char
      end
    end

    def connect_char_right?(x : Int32, y : Int32) : Bool
      cell = @grid.[x, y + 1]
      return false unless cell
      ["┐", "┬", "┤", "┼", "┘", "┴", "─"].includes?(cell.char)
    end

    def connect_right(char : String) : String
      case char
      when "┘"
        "┴"
      when "┐"
        "┬"
      when "┤"
        "┼"
      when "│"
        "├"
      else
        char
      end
    end

    def is_grid_char?(char : String) : Bool
      ["┌", "┬", "┐", "├", "┼", "┤", "└", "┴", "┘", "│", "─"].includes?(char)
    end
  end
end
