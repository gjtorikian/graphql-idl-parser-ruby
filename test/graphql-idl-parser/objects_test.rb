require 'test_helper'

module GraphQL
  class IDLParserObjectsTest < Minitest::Test
    def test_it_works_with_objects
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'objects.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      results = parser.process

      assert_equal results[0][:typename], 'object'
      assert_nil results[0][:description]
      assert_equal 'CodeOfConduct', results[0][:name]

      assert_equal results[1][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', results[1][:description]
      assert_equal 'CodeOfConduct', results[1][:name]
      assert_equal 0, results[1][:implements].count

      assert_equal results[2][:typename], 'object'
      assert_nil results[2][:description]
      assert_equal 'PushAllowance', results[2][:name]
      assert_equal 1, results[2][:implements].count
      assert_equal 'Node', results[2][:implements][0]

      assert_equal results[3][:typename], 'object'
      assert_nil results[3][:description]
      assert_equal 'Release', results[3][:name]
      assert_equal 2, results[3][:implements].count
      assert_equal 'Node', results[3][:implements][0]
      assert_equal 'UniformResourceLocatable', results[3][:implements][1]

      assert_equal results[4][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', results[4][:description]
      assert_equal 'CodeOfConduct', results[4][:name]
      assert_equal 1, results[4][:fields].count
      assert_equal 'body', results[4][:fields][0][:name]
      assert_nil results[4][:fields][0][:description]
      assert_equal false, results[4][:fields][0][:deprecated]

      assert_equal results[5][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', results[5][:description]
      assert_equal 'CodeOfConduct', results[5][:name]
      assert_equal 1, results[5][:fields].count
      assert_equal 'body', results[5][:fields][0][:name]
      assert_equal 'The body of the CoC', results[5][:fields][0][:description]
      assert_equal false, results[5][:fields][0][:deprecated]

      assert_equal results[6][:typename], 'object'
      assert_equal 'key', results[6][:fields][0][:name]
      assert_equal 'String', results[6][:fields][0][:type_info][:name]
      assert_equal '!', results[6][:fields][0][:type_info][:info]

      assert_equal results[7][:typename], 'object'
      assert_equal 'edges', results[7][:fields][0][:name]
      assert_equal 'CommitCommentEdge', results[7][:fields][0][:type_info][:name]
      assert_equal '[]', results[7][:fields][0][:type_info][:info]

      assert_equal results[8][:typename], 'object'
      assert_equal 'suggestedReviewers', results[8][:fields][0][:name]
      assert_equal 'SuggestedReviewer', results[8][:fields][0][:type_info][:name]
      assert_equal '[]!', results[8][:fields][0][:type_info][:info]

      assert_equal results[9][:typename], 'object'
      assert_equal 'viewerCannotUpdateReasons', results[9][:fields][0][:name]
      assert_equal 'CommentCannotUpdateReason', results[9][:fields][0][:type_info][:name]
      assert_equal '[!]!', results[9][:fields][0][:type_info][:info]

      assert_equal results[10][:typename], 'object'
      assert_equal 'followers', results[10][:fields][0][:name]
      assert_equal 'FollowerConnection', results[10][:fields][0][:type_info][:name]
      assert_equal '!', results[10][:fields][0][:type_info][:info]
      assert_equal 2, results[10][:fields][0][:arguments].count
      assert_equal 'Returns the elements in the list that come after the specified global ID.', results[10][:fields][0][:arguments][0][:description]
      assert_equal 'after', results[10][:fields][0][:arguments][0][:name]
      assert_equal 'String', results[10][:fields][0][:arguments][0][:type_info][:name]
      assert_equal '', results[10][:fields][0][:arguments][0][:type_info][:info]
      assert_equal 'Returns the first _n_ elements from the list.', results[10][:fields][0][:arguments][1][:description]
      assert_equal 'first', results[10][:fields][0][:arguments][1][:name]
      assert_equal 'Int', results[10][:fields][0][:arguments][1][:type_info][:name]
      assert_equal '!', results[10][:fields][0][:arguments][1][:type_info][:info]

      assert_equal results[11][:typename], 'object'
      assert_equal 'User', results[11][:name]
      assert_equal true, results[11][:fields][0][:deprecated]
      assert_nil results[11][:fields][0][:deprecation_reason]

      assert_equal results[12][:typename], 'object'
      assert_equal 'User', results[12][:name]
      assert_equal true, results[12][:fields][0][:deprecated]
      assert_equal 'Exposed database IDs will eventually be removed in favor of global Relay IDs.', results[12][:fields][0][:deprecation_reason]
    end
  end
end
