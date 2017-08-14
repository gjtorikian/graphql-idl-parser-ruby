require 'test_helper'

module GraphQL
  class IDLParserInterfacesTest < Minitest::Test
    def test_it_works_with_enums
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'interfaces.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      types = parser.process.types

      assert_equal 'interface', types[0][:typename]
      assert_equal 'Closable', types[0][:name]
      assert_equal 'An object that can be closed', types[0][:description]
      assert_equal 1, types[0][:fields].count
      assert_equal 'closed', types[0][:fields][0][:name]
      assert_equal '`true` if the object is closed (definition of closed may depend on type)', types[0][:fields][0][:description]
      assert_equal 'Boolean', types[0][:fields][0][:type_info][:name]
      assert_equal '!', types[0][:fields][0][:type_info][:info]
    end
  end
end
