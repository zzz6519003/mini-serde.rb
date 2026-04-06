# Mini-Serde.rb

A minimal JSON serialization library for Ruby, inspired by Rust's [mini-serde](https://github.com/dtolnay/mini-serde).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mini-serde'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mini-serde

## Usage

```ruby
require 'mini_serde'

# Serialize built-in types
json_str = MiniSerde.to_json_string("hello")  # => "\"hello\""
json_str = MiniSerde.to_json_string([1, 2, 3])  # => "[1,2,3]"

# Deserialize built-in types
value = MiniSerde.from_str('"hello"')  # => "hello"
value = MiniSerde.from_str('[1,2,3]')  # => [1.0, 2.0, 3.0]

# For custom classes, include the Serializable module for automatic serialization
class Person
  include MiniSerde::Serializable

  attr_accessor :name, :age, :tags

  def initialize(name, age, tags = [])
    @name = name
    @age = age
    @tags = tags
  end
end

person = Person.new("Alice", 30, ["developer", "ruby"])
json_str = MiniSerde.to_json_string(person)
# => "{\"age\":30,\"name\":\"Alice\",\"tags\":[\"developer\",\"ruby\"]}"

# Deserialize back to Person
parsed_person = Person.from_json_value(MiniSerde::Parser.parse(json_str))
# => #<Person:0x... @name="Alice", @age=30, @tags=["developer", "ruby"]>

# Manual implementation (alternative)
class ManualPerson
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_json_value
    MiniSerde::Json.object({
      "name" => @name,
      "age" => @age
    })
  end

  def self.from_json_value(json)
    obj = json.value[1]  # [:object, hash]
    ManualPerson.new(obj["name"], obj["age"])
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/mini-serde.rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).