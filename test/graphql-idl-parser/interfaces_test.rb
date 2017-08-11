require 'test_helper'

module GraphQL
  class IDLParserInterfacesTest < Minitest::Test
    def test_it_works_with_enums
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'interfaces.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      results = parser.process

      assert_equal 'interface', results[0][:typename]
      assert_equal 'Closable', results[0][:name]
      assert_equal "An object that can be closed", results[0][:description]
      assert_equal 1, results[0][:fields].count
      assert_equal 'closed', results[0][:fields][0][:name]
      assert_equal '`true` if the object is closed (definition of closed may depend on type)', results[0][:fields][0][:description]
      assert_equal 'Boolean', results[0][:fields][0][:type_info][:name]
      assert_equal '!', results[0][:fields][0][:type_info][:info]
    end
  end
end
