module MiniSerde
  class Json
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def self.null
      Json.new(:null)
    end

    def self.bool(b)
      Json.new([:bool, b])
    end

    def self.number(n)
      Json.new([:number, n])
    end

    def self.string(s)
      Json.new([:string, s])
    end

    def self.array(arr)
      Json.new([:array, arr])
    end

    def self.object(obj)
      Json.new([:object, obj])
    end

    def to_string
      case @value
      when :null
        'null'
      when Array
        type, val = @value
        case type
        when :bool
          val.to_s
        when :number
          val.to_i == val ? val.to_i.to_s : val.to_s
        when :string
          "\"#{escape_str(val)}\""
        when :array
          "[#{val.map(&:to_string).join(',')}]"
        when :object
          pairs = val.map { |k, v| "\"#{escape_str(k)}\":#{v.to_string}" }.sort
          "{#{pairs.join(',')}}"
        end
      end
    end

    private

    def escape_str(s)
      s.gsub('\\', '\\\\').gsub('"', '\\"').gsub("\n", "\\n")
    end
  end
end