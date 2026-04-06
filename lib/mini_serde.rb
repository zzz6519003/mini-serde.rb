require_relative 'mini_serde/json'
require_relative 'mini_serde/parser'
require_relative 'mini_serde/serialize'
require_relative 'mini_serde/deserialize'
require_relative 'mini_serde/primitives'
require_relative 'mini_serde/serializable'

module MiniSerde
  def self.to_json_string(value)
    value.to_json_value.to_string
  end

  def self.from_str(s)
    json = Parser.parse(s)
    Deserialize.from_json_value(json)
  end
end