module Hydra
  class Cell
    getter :tags
    property :char
    def initialize()
      @char = " "
      @tags = Array(String).new
    end

    def initialize(char : String, tags : Array(String))
      @char = char
      @tags = tags
    end
  end
end
