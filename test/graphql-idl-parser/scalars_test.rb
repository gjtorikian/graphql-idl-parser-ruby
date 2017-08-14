require 'test_helper'

module GraphQL
  class IDLParserScalarsTest < Minitest::Test
    def test_it_works_with_scalars
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'scalars.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      types = parser.process.types

      assert_equal 'scalar', types[0][:typename]
      assert_nil types[0][:description]
      assert_equal 'DateTime', types[0][:name]

      assert_equal 'scalar', types[1][:typename]
      assert_equal 'An ISO-8601 encoded UTC date string.', types[1][:description]
      assert_equal 'DateTime', types[1][:name]
    end
  end
end
