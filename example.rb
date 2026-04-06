#!/usr/bin/env ruby

require_relative 'lib/mini_serde'

# Example with built-in types
puts "=== Built-in Types ==="
puts "String: #{MiniSerde.to_json_string('hello')}"
puts "Number: #{MiniSerde.to_json_string(42)}"
puts "Array: #{MiniSerde.to_json_string([1, 2, 3])}"
puts "Hash: #{MiniSerde.to_json_string({'a' => 1, 'b' => 2})}"

# Example with custom struct using Serializable
class Person
  include MiniSerde::Serializable

  attr_accessor :name, :age, :tags

  def initialize(name, age, tags = [])
    @name = name
    @age = age
    @tags = tags
  end
end

puts "\n=== Custom Struct ==="
person = Person.new("Alice", 30, ["developer", "ruby"])
json_str = MiniSerde.to_json_string(person)
puts "Serialized: #{json_str}"

# Deserialize
parsed_json = MiniSerde::Parser.parse(json_str)
parsed_person = Person.from_json_value(parsed_json)
puts "Deserialized name: #{parsed_person.name}"
puts "Deserialized age: #{parsed_person.age}"
puts "Deserialized tags: #{parsed_person.tags.inspect}"