require 'test_helper'

module GraphQL
  class IDLParserUnionsTest < Minitest::Test
    def test_it_works_with_unions
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'unions.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      types = parser.process.types

      assert_equal 'union', types[0][:typename]
      assert_equal 'Any referencable object', types[0][:description]
      assert_equal 'ReferencedSubject', types[0][:name]
      assert_equal 2, types[0][:values].count
      assert_equal 'Issue', types[0][:values][0]
      assert_equal 'PullRequest', types[0][:values][1]
    end
  end
end
