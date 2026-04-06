require 'mini_serde'

RSpec.describe MiniSerde do
  describe '.to_json_string' do
    it 'serializes strings' do
      expect(MiniSerde.to_json_string("hello")).to eq('"hello"')
    end

    it 'serializes numbers' do
      expect(MiniSerde.to_json_string(42)).to eq('42')
      expect(MiniSerde.to_json_string(3.14)).to eq('3.14')
    end

    it 'serializes booleans' do
      expect(MiniSerde.to_json_string(true)).to eq('true')
      expect(MiniSerde.to_json_string(false)).to eq('false')
    end

    it 'serializes arrays' do
      expect(MiniSerde.to_json_string([1, 2, 3])).to eq('[1,2,3]')
    end

    it 'serializes hashes' do
      expect(MiniSerde.to_json_string({"a" => 1, "b" => 2})).to eq('{"a":1,"b":2}')
    end

    it 'serializes custom objects with Serializable' do
      class SimplePerson
        include MiniSerde::Serializable
        attr_accessor :name, :age
        def initialize(name, age)
          @name = name
          @age = age
        end
      end

      person = SimplePerson.new("Alice", 30)
      json_str = MiniSerde.to_json_string(person)
      expect(json_str).to eq('{"age":30,"name":"Alice"}')
    end
  end

  describe '.from_str' do
    it 'deserializes strings' do
      expect(MiniSerde.from_str('"hello"')).to eq('hello')
    end

    it 'deserializes numbers' do
      expect(MiniSerde.from_str('42')).to eq(42.0)
    end

    it 'deserializes booleans' do
      expect(MiniSerde.from_str('true')).to eq(true)
      expect(MiniSerde.from_str('false')).to eq(false)
    end

    it 'deserializes arrays' do
      expect(MiniSerde.from_str('[1,2,3]')).to eq([1.0, 2.0, 3.0])
    end

    it 'deserializes hashes' do
      expect(MiniSerde.from_str('{"a":1,"b":2}')).to eq({"a" => 1.0, "b" => 2.0})
    end
  end

  describe 'Serializable module' do
    class TestPerson
      include MiniSerde::Serializable
      attr_accessor :name, :age, :tags
      def initialize(name, age, tags = [])
        @name = name
        @age = age
        @tags = tags
      end
    end

    it 'serializes objects' do
      person = TestPerson.new("Alice", 30, ["dev", "ruby"])
      json_str = person.to_json_string
      expect(json_str).to eq('{"age":30,"name":"Alice","tags":["dev","ruby"]}')
    end

    it 'deserializes objects' do
      json = MiniSerde::Parser.parse('{"age":25,"name":"Bob","tags":["admin"]}')
      person = TestPerson.from_json_value(json)
      expect(person.name).to eq("Bob")
      expect(person.age).to eq(25.0)
      expect(person.tags).to eq(["admin"])
    end

    it 'round-trips serialization and deserialization' do
      person = TestPerson.new("Alice", 30, ["developer", "ruby"])
      json_str = person.to_json_string
      parsed_person = TestPerson.from_json_string(json_str)
      expect(parsed_person.name).to eq("Alice")
      expect(parsed_person.age).to eq(30.0)
      expect(parsed_person.tags).to eq(["developer", "ruby"])
    end
  end
end