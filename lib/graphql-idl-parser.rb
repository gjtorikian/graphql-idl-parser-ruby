require 'graphql-idl-parser/graphqlidlparser'
require 'graphql-idl-parser/version'

module GraphQL
  class IDLParser
    def initialize(filename)
      unless File.exist?(filename)
        raise ArgumentError, "#{filename} does not exist!"
      end

      unless filename.is_a?(String)
        raise TypeError, "Expected String, got #{filename.class}"
      end

      @filename = filename
    end
  end
end
