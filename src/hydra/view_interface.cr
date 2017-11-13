module Hydra
  class ViewInterface
    def initialize(x : Int, y : Int)
      @open = true
    end

    def close
      @open = false
    end

    def closed?
      !@open
    end

    def dump
      ""
    end

    def getch
      0
    end

    def clear
    end

    def commit
    end

    def print(x : Int, y : Int, text : String)
    end
  end
end
