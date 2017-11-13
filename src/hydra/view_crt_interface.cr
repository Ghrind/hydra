require "crt"
require "./view_interface"

module Hydra
  class ViewCrtInterface < ViewInterface
    def initialize(x : Int32, y : Int32)
      @win = Crt::Window.new(x, y)
      super
    end

    def print(x : Int32, y : Int32, text : String)
      @win.print(x, y, text)
    end

    def commit
      @win.refresh
    end

    def clear
      @win.clear
    end

    def getch
      @win.getch
    end

    def close
      Crt.done
    end
  end
end
