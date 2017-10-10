class View
  def initialize(win : Crt::Window)
    @win = win
    @elements = Array(Element).new
  end

  def render
    @win.clear
    @elements.each do |el|
      render_element(el)
    end
    @win.refresh
  end

  def add_element(element)
    @elements << element
  end

  def element(name) Element
    @elements.find { |e| e.name == name }
  end

  def render_element(element : Element)
    x = @win.row / 2 - element.height / 2
    y = @win.col / 2 - element.width / 2

    i = 0
    element.content.each_line do |l|
      @win.print(x + i, y, l)
      i += 1
    end
  end
end
