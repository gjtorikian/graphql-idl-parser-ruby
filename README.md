# GraphQL-IDL-Parser

This gem will accept a GraphQL IDL file and parse it. It uses [gjtorikian/graphql-idl-parser](https://github.com/gjtorikian/graphql-idl-parser) as the mechanism
for this, which is written in Rust, making this blazing fast.

[![Build Status](https://travis-ci.org/gjtorikian/graphql-idl-parser-ruby.svg?branch=master)](https://travis-ci.org/gjtorikian/graphql-idl-parser-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-idl-parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-idl-parser

## Usage

``` ruby
# feed it a file
parser = GraphQL::IDLParser.new(filename: contents)

# or feed it a string
parser = GraphQL::IDLParser.new(schema: contents)

# execute!
results = parser.process
```
