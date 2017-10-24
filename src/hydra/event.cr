module Hydra
  class Event
    property :name
    property :keypress
    @keypress : Hydra::Keypress | Nil

    def initialize(name : String)
      @name = name
      @keypress = nil
    end
  end
end
