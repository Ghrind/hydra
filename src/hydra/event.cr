module Hydra
  class Event
    property :name
    property :char

    def initialize(name : String)
      @name = name
      @char = ""
    end
  end
end
