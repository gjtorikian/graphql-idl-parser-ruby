require 'test_helper'

module GraphQL
  class IDLParserUnionsTest < Minitest::Test
    def test_it_works_with_unions
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'unions.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      results = parser.process

      assert_equal 'union', results[0][:typename]
      assert_equal 'Any referencable object', results[0][:description]
      assert_equal 'ReferencedSubject', results[0][:name]
      assert_equal 2, results[0][:values].count
      assert_equal 'Issue', results[0][:values][0]
      assert_equal 'PullRequest', results[0][:values][1]
    end
  end
end
