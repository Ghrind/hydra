require "spec"
require "../../src/hydra/prompt"

describe "Prompt" do
  describe "#content" do
    it "displays a boxed version of the content" do
      prompt = Hydra::Prompt.new("id")
      prompt.append("foobar")
      prompt.content.string.should eq ["┌────────────────────────────┐",
                                       "│foobar                      │",
                                       "└────────────────────────────┘"].join("\n")
    end

    context "with a label" do
      it "shows the label in the top bar" do
        prompt = Hydra::Prompt.new("id", {:label => "toto"})
        prompt.append("foobar")
        prompt.content.string.should eq ["┌─toto───────────────────────┐",
                                         "│foobar                      │",
                                         "└────────────────────────────┘"].join("\n")
      end
    end

    context "when the value is bigger than the size of the prompt" do
      it "shows the end of the value" do
      prompt = Hydra::Prompt.new("id")
      prompt.append("abcdefghijklmnopqrstuvwxyz1234567890")
      prompt.content.string.should eq ["┌────────────────────────────┐",
                                       "│…jklmnopqrstuvwxyz1234567890│",
                                       "└────────────────────────────┘"].join("\n")
      end
    end
  end

  describe "#width" do
    it "is fixed to 30" do
      prompt = Hydra::Prompt.new("id")
      prompt.width.should eq 30
    end
  end

  describe "#height" do
    it "is fixed to 3" do
      prompt = Hydra::Prompt.new("id")
      prompt.height.should eq 3
    end
  end

  describe "#remove_last" do
    it "removes the last character of the value" do
      prompt = Hydra::Prompt.new("id")
      prompt.append("foobar")
      prompt.remove_last
      prompt.value.should eq "fooba"
    end

    context "when the value is blank" do
      it "leaves the value blank" do
        prompt = Hydra::Prompt.new("id")
        prompt.remove_last
        prompt.value.should eq ""
      end
    end
  end

  describe "#append" do
    it "adds the given string to the current value" do
      prompt = Hydra::Prompt.new("id")
      prompt.append("foo")
      prompt.append("bar")
      prompt.value.should eq "foobar"
    end
  end

  describe "#clear" do
    it "resets the value to a blank state" do
      prompt = Hydra::Prompt.new("id")
      prompt.append("foobar")
      prompt.clear
      prompt.value.should eq ""
    end
  end

end
