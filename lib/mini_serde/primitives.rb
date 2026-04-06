require_relative 'json'

# Implement Serialize for built-in types
class String
  def to_json_value
    MiniSerde::Json.string(self)
  end
end

class Integer
  def to_json_value
    MiniSerde::Json.number(self.to_f)
  end
end

class Float
  def to_json_value
    MiniSerde::Json.number(self)
  end
end

class TrueClass
  def to_json_value
    MiniSerde::Json.bool(true)
  end
end

class FalseClass
  def to_json_value
    MiniSerde::Json.bool(false)
  end
end

class Array
  def to_json_value
    MiniSerde::Json.array(self.map(&:to_json_value))
  end
end

class Hash
  def to_json_value
    MiniSerde::Json.object(self.transform_values(&:to_json_value))
  end
end

# Implement Deserialize for built-in types
module MiniSerde
  module Deserialize
    def self.from_json_value(json)
      val = json.value
      if val == :null
        nil
      elsif val.is_a?(Array) && val[0] == :bool
        val[1]
      elsif val.is_a?(Array) && val[0] == :number
        val[1]
      elsif val.is_a?(Array) && val[0] == :string
        val[1]
      elsif val.is_a?(Array) && val[0] == :array
        val[1].map { |el| Deserialize.from_json_value(el) }
      elsif val.is_a?(Array) && val[0] == :object
        val[1].transform_values { |v| Deserialize.from_json_value(v) }
      else
        raise "Unknown JSON type: #{val}"
      end
    end
  end
end