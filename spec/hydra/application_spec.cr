require "spec"
require "../../src/hydra/application"

class TestScreen < Hydra::Screen
  @chars : Array(Int32)
  property :chars

  def getch() : Int32
    return 0 if @chars.size.zero?
    @chars.shift
  end

  def initialize(x : Int32, y : Int32)
    @chars = Array(Int32).new
    super
  end
end

describe "Application" do
  describe ".setup" do
    it "should setup a whole application properly" do
      Hydra::Application.setup
    end
  end

  it "should start an application and stop it" do
    screen = TestScreen.new(50, 100)
    screen.chars = [24] # 24 => ctrl-x

    app = Hydra::Application.setup(screen: screen)
    app.bind("keypress.ctrl-x", "application", "stop")
    app.run
  end
end
