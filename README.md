# Procreate::Swatches

A gem to interact with [Procreate](https://procreate.art) `.swatches` files.

This gem offers the possibility to:
* parse an existing `.swatches` color palette to an object and extract the colors in various color formats
* generate a Procreate color palette from an array of colors and export it to a `.swatches` file

Behind the scenes, `Procreate::Swatches` uses the [Chroma gem](https://github.com/jfairbank/chroma) to wrap colors and provide a better experience in interacting with colors. For more in depth use cases, consult the documentation for `Chroma::Color`, available [here](https://www.rubydoc.info/gems/chroma/0.2.0/Chroma/Color).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'procreate-swatches'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install procreate-swatches

## Usage

Before using the gem, you have to require the main file:
```ruby
require 'procreate/swatches'
```

### Parsing

The gem allows you to parse an existing `.swatches` file to a `Procreate::Swatches::Wrapper` instance, which will allow you to further manipulate the colors.

_For full documentation, refer to [Procreate::Swatches::Parser documentation](https://www.rubydoc.info/gems/procreate-swatches/Procreate/Swatches/Parser)_

__*Example 1*__
```ruby
file_path = '/file/path/to/palette.swatches'
# Initialize a new instance of `Procreate::Swatches::Parser` with the file path to the `.swatches` file
parser = Procreate::Swatches::Parser.new(file_path)
# Use the method `#call` to parse the file; this will return an instance of `Procreate::Swatches::Wrapper`
wrapper = parser.call
```

__*Example 2*__

For ease of use, a `.call` method is available:
```ruby
file_path = '/file/path/to/palette.swatches'
wrapper = Procreate::Swatches::Parser.call(file_path)
```

__*Example 3*__

For convenience, a top-level method can be used to parse a `.swatches` file
```ruby
file_path = '/file/path/to/palette.swatches'
wrapper = Procreate::Swatches.parse(file_path)
# which is also aliased as `.from_file`
wrapper = Procreate::Swatches.from_file(file_path)
```

### Interacting with a wrapped palette

_For full documentation, refer to [Procreate::Swatches::Wrapper documentation](https://www.rubydoc.info/gems/procreate-swatches/Procreate/Swatches/Wrapper)_

After successfully converting a `.swatches` file to a `Procreate::Swatches::Wrapper` instance, you can further interact with the palette in a Ruby way.

Using the `Procreate::Swatches::Wrapper`, you can access the name and the colors array of the `.swatches` file.

```ruby
wrapper.name
# => "Snowy Landscape"

wrapper.colors
# => [hsv(195, 16%, 81%), hsv(288, 6%, 68%), hsv(232, 19%, 67%)]
```

By default, each color available in the colors array is an instance of `Chroma::Color`.

By providing a format parameter to the `#colors` method, you can retrieve the colors in one of the available formats (supported by `Chroma::Color`)
```ruby
# converting to hex
wrapper.colors(format: :hex)
# => ["#aec6cf", "#aba3ad", "#8a8fab"]
```

All the available formats for converting colors:
```ruby
wrapper.available_color_formats
# => [:hsv, :hsl, :hex, :hex8, :rgb, :name]

# the list is also available using
Procreate::Swatches::Wrapper::AVAILABLE_COLOR_FORMATS
```

To add a new color to the wrapper's colors array, use the `push` or `<<` method
```ruby
wrapper.push("#aaa")
# => [hsv(195, 16%, 81%), hsv(288, 6%, 68%), hsv(232, 19%, 67%), #aaa]
wrapper << "#bbb"
# => [hsv(195, 16%, 81%), hsv(288, 6%, 68%), hsv(232, 19%, 67%), #aaa, #bbb]
```
This will add the color to the array (if valid) and return the colors array, including the newly-added color. Note that each color is an instance of `Chroma::Color`

For convenience, you can directly export a `Procreate::Swatches::Wrapper` instance to a `.swatches` file:
```ruby
wrapper.export
# => "path/to/your/palette.swatches"

# which is also aliased as
wrapper.to_file
# => "path/to/your/palette-1.swatches"
```

### Exporting

_For full documentation, refer to [Procreate::Swatches::Exporter documentation](https://www.rubydoc.info/gems/procreate-swatches/Procreate/Swatches/Exporter)_

You can easily export a `Procreate::Swatches::Wrapper` to a `.swatches` file.

__*Example 1*__

```ruby
exporter = Procreate::Swatches::Exporter.new(wrapper, options)

swatches_path = export.call
# => "path/to/your/palette.swatches"
```

The `.swatches` path is also available afterwards, using the `swatches_path` attribute:
```ruby
exporter.swatches_path
# => "path/to/your/palette.swatches"
```

__*Example 2*__

For ease of use, a `.call` method is available:
```ruby
swatches_path = Procreate::Swatches::Exporter.call(wrapper, options)
```

__*Example 3*__

For convenience, a top-level method can be used to export an array of colors to a `.swatches` file:
```ruby
name = 'Snowy landscape'
colors = ["#aaa", "#bbb", "#ccc"]

swatches_path = Procreate::Swatches.export(name, colors)
# => "path/to/your/snowy_landscape.swatches"


# which is also aliased as
swatches_path = Procreate::Swatches.to_file(name, colors)
# => "path/to/your/snowy_landscape-1.swatches"
```

#### Export options

The `Procreate::Swatches::Exporter` class supports a number of options while exporting to a `.swatches` file.

```ruby
options = { export_directory: '/Users/username/Desktop' }

swatches_path = Procreate::Swatches.to_file(name, colors, options)
# => "/Users/username/Desktop/snowy_landscape.swatches"
```

```ruby
options = {
  export_directory = '/Users/username/Desktop',
  file_name: 'gorgeous_palette'
}

swatches_path = Procreate::Swatches.to_file(name, colors, options)
# => "/Users/username/Desktop/gorgeous_palette.swatches"
```

The default values for these options are:
```ruby
# The result of calling `Dir.pwd`, which returns the current working directory
export_directory = Dir.pwd

# The sanitized string of the `Procreate::Swatches::Wrapper` name
file_name = wrapper.name
```

These options are supported on every method that can export a `.swatches` file:

```ruby
Procreate::Swatches::Exporter.new(wrapper, options).call

Procreate::Swatches::Exporter.call(wrapper, options)

Procreate::Swatches.to_file(name, colors, options)

Procreate::Swatches.export(name, colors, options)

wrapper.export(options)

wrapper.to_file(options)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/laurentzziu/procreate-swatches>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `Procreate::Swatches` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/laurentzziu/procreate-swatches/blob/master/CODE_OF_CONDUCT.md).
