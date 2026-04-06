module MiniSerde
  module Serialize
    def to_json_value
      raise NotImplementedError
    end
  end
end