require "./extended_string"

module Hydra
  class StringParser
    getter :chunks

    TAG_START_CHAR = "<"
    TAG_END_CHAR = ">"
    TAG_CLOSE_CHAR = "/"
    ESCAPE_CHAR = "\\"

    def initialize(string : String)
      @in_tag = false
      @closing_tag = false
      @tag = ""
      @current_chunk = ExtendedString.new("")
      @chunks = Array(ExtendedString).new
      @string = string
      @escape = false
    end

    def parse!
      each_char do |char|
        if char == ESCAPE_CHAR
          @escape = true
          next
        end
        if char == TAG_START_CHAR
          if @escape
            @escape = false
          else
            start_tag
            next
          end
        end
        if @escape
          @escape = false
          if @in_tag
            @tag += ESCAPE_CHAR
          else
            @current_chunk.string += ESCAPE_CHAR
          end
        end
        case char
        when TAG_CLOSE_CHAR
          if in_blank_tag?
            @closing_tag = true
            next
          end
        when TAG_END_CHAR
          if @in_tag
            end_tag
            next
          end
        end
        if @in_tag
          @tag += char
        else
          @current_chunk.string += char
        end
      end
      if @escape
        @escape = false
        if @in_tag
          @tag += ESCAPE_CHAR
        else
          @current_chunk.string += ESCAPE_CHAR
        end
      end
      store_current_chunk
    end

    private def each_char(&block)
      @string.split("").each do |char|
        yield char
      end
    end

    private def start_tag()
      store_current_chunk
      new_chunk = ExtendedString.new("")
      new_chunk.tags = @current_chunk.tags.dup
      @current_chunk = new_chunk
      @in_tag = true
    end

    private def end_tag()
      if @closing_tag
        @current_chunk.tags.pop if @current_chunk.tags.size > 0 && @current_chunk.tags.last == @tag
      else
        @current_chunk.tags << @tag
      end
      @tag = ""
      @in_tag = false
      @closing_tag = false
    end

    private def in_blank_tag?() Bool
      @in_tag && @tag == ""
    end

    private def store_current_chunk
      @chunks << @current_chunk unless @current_chunk.string == ""
    end
  end
end
