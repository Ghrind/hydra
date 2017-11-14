module Hydra
  class Keypress
    MAPPING = {
      1 => "ctrl-a",
      3 => "ctrl-c",
      5 => "ctrl-e",
      13 => "enter",
      24 => "ctrl-x",
      127 => "backspace",
      27 => "escape"
    }

    getter :name
    getter :char
    @ctrl_pressed : Bool
    @char : String
    @name : String

    def initialize(key : Int32)
      if MAPPING[key]?
        @name = MAPPING[key]
        @char = ""
      else
        @name = key.chr.to_s
        @char = key.chr.to_s
      end
      @ctrl_pressed = (@name =~ /^ctrl-/ ? true : false)
    end

    def ctrl_pressed?() : Bool
      @ctrl_pressed
    end
  end
end
