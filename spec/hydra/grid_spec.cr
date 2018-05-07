require "spec"
require "../../src/hydra/grid"

describe "Grid" do
  describe "#[]" do
    it "returns the value at x,y" do
      grid = Hydra::Grid.new(3, 3)
      grid[1, 2] = "a"
      grid[1, 2].should eq "a"
    end
    context "when x,y are out of bounds" do
      it "returns nil" do
        grid = Hydra::Grid.new(0, 0)
        grid[1, 1].should eq nil
      end
    end
  end
  describe "#[]=" do
    it "sets the value at coordinates" do
      grid = Hydra::Grid.new(3, 3)
      grid[1, 2] = "a"
      grid.dump.should eq ["   ",
                           "  a",
                           "   "].join("\n")
    end
  end
  describe "#clear" do
    it "removes all values" do
      grid = Hydra::Grid.new(3, 3)
      grid[1, 2] = "a"
      grid.clear
      grid.dump.should eq ["   ",
                           "   ",
                           "   "].join("\n")
    end
  end

  describe "#dump" do
    it "returns a string with the grid's content" do
      grid = Hydra::Grid.new(2, 2)
      grid[0, 0] = "a"
      grid[0, 1] = "b"
      grid[1, 0] = "c"
      grid[1, 1] = "d"

      grid.dump.should eq ["ab",
                           "cd"].join("\n")
    end
  end

  describe "#each" do
    it "iterates through all the elements, with their indexes" do
      grid = Hydra::Grid.new(2, 2)
      grid[0, 0] = "a"
      grid[0, 1] = "b"
      grid[1, 0] = "c"
      grid[1, 1] = "d"

      result = Array(String).new

      grid.each do |char, x, y|
        result.push("#{char},#{x},#{y}")
      end

      result.should eq ["a,0,0", "b,0,1", "c,1,0", "d,1,1"]
    end
  end
end
