require 'test_helper'

module GraphQL
  class IDLParserObjectsTest < Minitest::Test
    def test_it_works_with_objects
      schema = File.read(File.join(RUST_FIXTURES_DIR, 'objects.graphql'))
      parser = GraphQL::IDLParser.new(schema: schema)
      types = parser.process.types

      assert_equal types[0][:typename], 'object'
      assert_nil types[0][:description]
      assert_equal 'CodeOfConduct', types[0][:name]

      assert_equal types[1][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', types[1][:description]
      assert_equal 'CodeOfConduct', types[1][:name]
      assert_equal 0, types[1][:implements].count

      assert_equal types[2][:typename], 'object'
      assert_nil types[2][:description]
      assert_equal 'PushAllowance', types[2][:name]
      assert_equal 1, types[2][:implements].count
      assert_equal 'Node', types[2][:implements][0]

      assert_equal types[3][:typename], 'object'
      assert_nil types[3][:description]
      assert_equal 'Release', types[3][:name]
      assert_equal 2, types[3][:implements].count
      assert_equal 'Node', types[3][:implements][0]
      assert_equal 'UniformResourceLocatable', types[3][:implements][1]

      assert_equal types[4][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', types[4][:description]
      assert_equal 'CodeOfConduct', types[4][:name]
      assert_equal 1, types[4][:fields].count
      assert_equal 'body', types[4][:fields][0][:name]
      assert_nil types[4][:fields][0][:description]
      assert_equal 0, types[4][:fields][0][:directives].length

      assert_equal types[5][:typename], 'object'
      assert_equal 'The Code of Conduct for a repository', types[5][:description]
      assert_equal 'CodeOfConduct', types[5][:name]
      assert_equal 1, types[5][:fields].count
      assert_equal 'body', types[5][:fields][0][:name]
      assert_equal 'The body of the CoC', types[5][:fields][0][:description]
      assert_equal 0, types[4][:fields][0][:directives].length

      assert_equal types[6][:typename], 'object'
      assert_equal 'key', types[6][:fields][0][:name]
      assert_equal 'String', types[6][:fields][0][:type_info][:name]
      assert_equal '!', types[6][:fields][0][:type_info][:info]

      assert_equal types[7][:typename], 'object'
      assert_equal 'edges', types[7][:fields][0][:name]
      assert_equal 'CommitCommentEdge', types[7][:fields][0][:type_info][:name]
      assert_equal '[]', types[7][:fields][0][:type_info][:info]

      assert_equal types[8][:typename], 'object'
      assert_equal 'suggestedReviewers', types[8][:fields][0][:name]
      assert_equal 'SuggestedReviewer', types[8][:fields][0][:type_info][:name]
      assert_equal '[]!', types[8][:fields][0][:type_info][:info]

      assert_equal types[9][:typename], 'object'
      assert_equal 'viewerCannotUpdateReasons', types[9][:fields][0][:name]
      assert_equal 'CommentCannotUpdateReason', types[9][:fields][0][:type_info][:name]
      assert_equal '[!]!', types[9][:fields][0][:type_info][:info]

      assert_equal types[10][:typename], 'object'
      assert_equal 'followers', types[10][:fields][0][:name]
      assert_equal 'FollowerConnection', types[10][:fields][0][:type_info][:name]
      assert_equal '!', types[10][:fields][0][:type_info][:info]
      assert_equal 2, types[10][:fields][0][:arguments].count
      assert_equal 'Returns the elements in the list that come after the specified global ID.', types[10][:fields][0][:arguments][0][:description]
      assert_equal 'after', types[10][:fields][0][:arguments][0][:name]
      assert_equal 'String', types[10][:fields][0][:arguments][0][:type_info][:name]
      assert_equal '', types[10][:fields][0][:arguments][0][:type_info][:info]
      assert_equal 'Returns the first _n_ elements from the list.', types[10][:fields][0][:arguments][1][:description]
      assert_equal 'first', types[10][:fields][0][:arguments][1][:name]
      assert_equal 'Int', types[10][:fields][0][:arguments][1][:type_info][:name]
      assert_equal '!', types[10][:fields][0][:arguments][1][:type_info][:info]

      assert_equal types[11][:typename], 'object'
      assert_equal 'User', types[11][:name]
      assert_equal 1, types[11][:fields][0][:directives].length
      assert_equal 'deprecated', types[11][:fields][0][:directives][0][:name]
      assert_equal 0, types[11][:fields][0][:directives][0][:arguments].length

      assert_equal types[12][:typename], 'object'
      assert_equal 'Issue', types[12][:name]
      assert_equal 'deprecated', types[12][:fields][0][:directives][0][:name]
      assert_equal 1, types[12][:fields][0][:directives][0][:arguments].length
      assert_equal 'reason', types[12][:fields][0][:directives][0][:arguments][0][:name]
      assert_equal 'Exposed database IDs will eventually be removed in favor of global Relay IDs.', types[12][:fields][0][:directives][0][:arguments][0][:value]

      assert_equal 1, types[13][:fields].length
      assert_equal 'childTeams', types[13][:fields][0][:name]
      assert_equal 1, types[13][:fields][0][:arguments].length
      assert_equal 'immediateOnly', types[13][:fields][0][:arguments][0][:name]
      assert_equal 'Boolean', types[13][:fields][0][:arguments][0][:type_info][:name]
      assert_equal '', types[13][:fields][0][:arguments][0][:type_info][:info]
      assert_equal 'true', types[13][:fields][0][:arguments][0][:default_value]
    end
  end
end
