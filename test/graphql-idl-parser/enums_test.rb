require 'test_helper'

module GraphQL
  class IDLParserEnumsTest < Minitest::Test
    def test_it_works_with_enums
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'enums.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      types = parser.process.types

      assert_equal 'enum', types[0][:typename]
      assert_equal 'ProjectState', types[0][:name]
      assert_equal "State of the project; either 'open' or 'closed'", types[0][:description]
      assert_equal 2, types[0][:values].count
      assert_equal 'CLOSED', types[0][:values][0][:name]
      assert_equal 'The project is closed.', types[0][:values][0][:description]
      assert_equal 'OPEN', types[0][:values][1][:name]
      assert_equal 'The project is open.', types[0][:values][1][:description]
    end
  end
end
