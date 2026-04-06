module MiniSerde
  module Serializable
    def to_json_value
      attrs = {}
      instance_variables.each do |var|
        key = var.to_s[1..-1]  # remove @
        value = instance_variable_get(var)
        attrs[key] = value.to_json_value
      end
      Json.object(attrs)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def from_json_value(json)
        obj_hash = json.value[1]  # [:object, hash]
        instance = allocate
        obj_hash.each do |key, value|
          ruby_value = Deserialize.from_json_value(value)
          instance.instance_variable_set("@#{key}", ruby_value)
        end
        instance
      end
    end
  end
end