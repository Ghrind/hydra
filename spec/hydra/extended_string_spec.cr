require "spec"
require "../../src/hydra/extended_string"

describe "ExtendedString" do
  describe "#chunks" do
    context "with simple markup" do
      it "parses tags properly" do
        str = Hydra::ExtendedString.new("Hi <red-fg>Nathan</red-fg>!")
        str.chunks.map { |i| i.string }.should eq ["Hi ", "Nathan", "!"]
        str.chunks.map { |i| i.tags }.should eq [Array(Hydra::ExtendedString).new, ["red-fg"], Array(Hydra::ExtendedString).new]
      end
    end
    context "with complex markup" do
      it "parses tags properly" do
        str = Hydra::ExtendedString.new("Hi <bold><red-fg>Nathan</red-fg>!</bold>")
        str.chunks.map { |i| i.string }.should eq ["Hi ", "Nathan", "!"]
        str.chunks.map { |i| i.tags }.should eq [Array(Hydra::ExtendedString).new, ["bold", "red-fg"], ["bold"]]
      end
    end
    context "when closing a tag that is not open" do
      it "ignores the closing tag" do
        str = Hydra::ExtendedString.new("A</red-fg>B")
        str.chunks.map { |i| i.string }.should eq ["A", "B"]
        str.chunks.map { |i| i.tags }.should eq [Array(Hydra::ExtendedString).new, Array(Hydra::ExtendedString).new]
      end
    end
    context "when a tag is escaped" do
      it "treats the tag as plain text" do
        str = Hydra::ExtendedString.new("\\<foo>bla\\</foo>")
        str.chunks.map { |i| i.string }.should eq ["<foo>bla</foo>"]
        str.chunks.map { |i| i.tags }.should eq [Array(Hydra::ExtendedString).new]
      end
    end
    context "when there is a '\' in the string" do
      it "parses properly" do
        str = Hydra::ExtendedString.new("\\")
        str.chunks.map { |i| i.string }.should eq ["\\"]

        str = Hydra::ExtendedString.new("a\\")
        str.chunks.map { |i| i.string }.should eq ["a\\"]

        str = Hydra::ExtendedString.new("\\a")
        str.chunks.map { |i| i.string }.should eq ["\\a"]

        str = Hydra::ExtendedString.new("a\\a")
        str.chunks.map { |i| i.string }.should eq ["a\\a"]
      end
    end
  end
  describe ".escape" do
    it "escapes tags" do
      Hydra::ExtendedString.escape("<foo>").should eq "\\<foo>"
    end
  end
  describe "#stripped" do
    it "returns the string with no markup" do
      str = Hydra::ExtendedString.new("Hi <red-fg>Nathan</red-fg>!")
      str.stripped.should eq "Hi Nathan!"
    end
  end
end
