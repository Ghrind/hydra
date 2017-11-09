module Hydra
  class ElementCollection
    def initialize
      @elements = Array(Element).new
    end

    def by_id(id : String) : Element
      e = @elements.find { |e| e.id == id }
      raise "Element not found #{id}" unless e
      e
    end

    def push(element : Element)
      @elements.push(element)
    end

    def each(&block)
      @elements.each do |element|
        yield element
      end
    end
  end
end
