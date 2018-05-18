require "./keypress"

module Hydra
  class Event
    property :name
    property :keypress
    @keypress : Hydra::Keypress | Nil

    def initialize(keypress : Keypress)
      @name = "keypress.#{keypress.name}"
      @keypress = keypress
    end

    def initialize(name : String)
      @name = name
      @keypress = nil
    end
  end
end
