require_relative 'json'

module MiniSerde
  class Parser
    def initialize(s)
      @s = s
      @pos = 0
    end

    def self.parse(s)
      parser = Parser.new(s)
      parser.parse
    end

    def parse
      skip_ws
      value = parse_value
      skip_ws
      raise "trailing characters" unless @pos == @s.length
      value
    end

    private

    def peek
      @s[@pos]
    end

    def next_char
      ch = peek
      @pos += 1
      ch
    end

    def skip_ws
      while @pos < @s.length && @s[@pos].match?(/\s/)
        @pos += 1
      end
    end

    def parse_value
      skip_ws
      case peek
      when 'n'
        parse_null
      when 't', 'f'
        parse_bool
      when '"'
        Json.string(parse_string)
      when '['
        parse_array
      when '{'
        parse_object
      when '-', '0'..'9'
        parse_number
      else
        raise "unexpected char: #{peek}"
      end
    end

    def parse_null
      if @s[@pos..@pos+3] == 'null'
        @pos += 4
        Json.null
      else
        raise "invalid null"
      end
    end

    def parse_bool
      if @s[@pos..@pos+3] == 'true'
        @pos += 4
        Json.bool(true)
      elsif @s[@pos..@pos+4] == 'false'
        @pos += 5
        Json.bool(false)
      else
        raise "invalid bool"
      end
    end

    def parse_string
      raise "expected \"" unless next_char == '"'
      result = ''
      while @pos < @s.length
        ch = next_char
        if ch == '"'
          break
        elsif ch == '\\'
          ch = next_char
          case ch
          when 'n' then result += "\n"
          when '"' then result += '"'
          when '\\' then result += '\\'
          else result += ch
          end
        else
          result += ch
        end
      end
      result
    end

    def parse_number
      start = @pos
      @pos += 1 while @pos < @s.length && @s[@pos].match?(/[\d\.\-eE]/)
      num_str = @s[start...@pos]
      Json.number(num_str.to_f)
    end

    def parse_array
      raise "expected [" unless next_char == '['
      arr = []
      skip_ws
      if peek != ']'
        loop do
          arr << parse_value
          skip_ws
          break if peek == ']'
          raise "expected ," unless next_char == ','
        end
      end
      raise "expected ]" unless next_char == ']'
      Json.array(arr)
    end

    def parse_object
      raise "expected {" unless next_char == '{'
      obj = {}
      skip_ws
      if peek != '}'
        loop do
          key = parse_string
          skip_ws
          raise "expected :" unless next_char == ':'
          value = parse_value
          obj[key] = value
          skip_ws
          break if peek == '}'
          raise "expected ," unless next_char == ','
        end
      end
      raise "expected }" unless next_char == '}'
      Json.object(obj)
    end
  end
end