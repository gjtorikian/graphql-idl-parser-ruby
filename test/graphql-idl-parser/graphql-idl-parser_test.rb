require 'test_helper'

class GraphQLIDLParserTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GraphQLIDLParser::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_it_ffis
    parser = GraphQLIDLParser.new
    assert_equal 3, parser.result
  end
end
