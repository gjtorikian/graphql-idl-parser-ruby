require 'test_helper'

module GraphQL
  class IDLParserEnumsTest < Minitest::Test
    def test_it_works_with_enums
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'enums.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      results = parser.process

      assert_equal 'enum', results[0][:typename]
      assert_equal 'ProjectState', results[0][:name]
      assert_equal "State of the project; either 'open' or 'closed'", results[0][:description]
      assert_equal 2, results[0][:values].count
      assert_equal 'CLOSED', results[0][:values][0][:name]
      assert_equal 'The project is closed.', results[0][:values][0][:description]
      assert_equal 'OPEN', results[0][:values][1][:name]
      assert_equal 'The project is open.', results[0][:values][1][:description]
    end
  end
end
