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

## Benchmarks

Check it out with `bundle exec rake benchmark`:

```
Warming up --------------------------------------
           pure ruby     1.000  i/100ms
           this gem      7.000  i/100ms
Calculating -------------------------------------
           pure ruby      6.527  (± 0.0%) i/s -     33.000  in   5.082540s
           this gem      73.511  (± 5.4%) i/s -    371.000  in   5.064868s

Comparison:
           this gem :       73.5 i/s
           pure ruby:        6.5 i/s - 11.26x  slower
```
