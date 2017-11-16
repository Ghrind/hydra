require "crt"

module Hydra
  class Screen
    def initialize(x : Int32, y : Int32)
      @win = Crt::Window.new(x, y)
    end

    def update(content : String)
      @win.clear
      @win.print(0, 0, content)
      @win.refresh
    end

    def getch
      @win.getch
    end

    def close
      Crt.done
    end
  end
end
