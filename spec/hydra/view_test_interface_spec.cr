require "spec"
require "../src/hydra/view_test_interface"

describe "ViewTestInterface" do
  describe "#dump" do
    it "dumps an empty screen" do
      interface = Hydra::ViewTestInterface.new(4, 6)
      interface.dump.should eq ["      ",
                                "      ",
                                "      ",
                                "      "].join("\n")
    end
  end

  describe "#print" do
    it "prints the given string on the canvas" do
      interface = Hydra::ViewTestInterface.new(4, 6)
      interface.print(1, 2, "xo")
      interface.dump.should eq ["      ",
                                "  xo  ",
                                "      ",
                                "      "].join("\n")
    end
  end

  describe "clear" do
    it "remove everything that has been printed" do
      interface = Hydra::ViewTestInterface.new(4, 6)
      interface.print(1, 2, "xo")
      interface.clear
      interface.dump.should eq ["      ",
                                "      ",
                                "      ",
                                "      "].join("\n")
    end
  end
end
