# Eyra

Serialize/Deserializing ruby objects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eyra'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eyra

## Usage

```ruby
class MovieSerializer
  include Eyra
  
  field :title,type: String
  field :year,type: Integer
  
  dump_format :year_in_hex do
    year.to_i.to_s(16)
  end
end

MovieSerialize.new(@movie).to_json # { movie: 'The fight club', year: 1999}
```


### Benchmarks 
wip

### Alternatives

* `https://github.com/netflix/fast_jsonapi`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marianogabriels/eyra.

