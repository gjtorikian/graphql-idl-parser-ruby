require 'graphql-idl-parser/graphqlidlparser'
require 'graphql-idl-parser/version'

class GraphQLIDLParser
  def initialize
    @result = GraphQLIDLParser::Parser.new.process
  end

  def result
    @result
  end
end
