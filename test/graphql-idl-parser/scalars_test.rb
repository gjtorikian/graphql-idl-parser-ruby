require 'test_helper'

module GraphQL
  class IDLParserScalarsTest < Minitest::Test
    def test_it_works_with_scalars
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'scalars.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      results = parser.process

      assert_equal 'scalar', results[0][:typename]
      assert_nil results[0][:description]
      assert_equal 'DateTime', results[0][:name]

      assert_equal 'scalar', results[1][:typename]
      assert_equal 'An ISO-8601 encoded UTC date string.', results[1][:description]
      assert_equal 'DateTime', results[1][:name]
    end
  end
end
