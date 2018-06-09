module Hydra
  class ElementCollection
    def initialize(elements = Array(Element).new)
      @elements = elements
    end

    def by_id(id : String) : Element
      e = @elements.find { |e| e.id == id }
      raise "Element not found #{id}" unless e
      e
    end

    def push(element : Element)
      @elements.push(element)
    end

    def show_only(*element_ids)
      hide_all
      element_ids.each do |id|
        by_id(id).show
      end
    end

    def hide_all
      each do |element|
        element.hide
      end
    end

    def each(&block)
      @elements.each do |element|
        yield element
      end
    end

    def to_a
      @elements
    end
  end
end
