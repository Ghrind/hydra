require "./string_parser"

module Hydra
  class ExtendedString
    property :tags
    property :string

    def self.escape(string : String) String
      string.gsub(StringParser::TAG_START_CHAR, "#{StringParser::ESCAPE_CHAR}#{StringParser::TAG_START_CHAR}")
    end

    def initialize(string : String)
      @string = string
      @tags = Array(String).new
      @chunks = Array(ExtendedString).new
    end

    def chunks() Array(ExtendedString)
      parser = Hydra::StringParser.new(@string)
      parser.parse!
      parser.chunks
    end

    def stripped() String
      chunks.map { |i| i.string }.join("")
    end
  end
end
