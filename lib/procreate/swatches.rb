# frozen_string_literal: true

require 'chroma'
require 'callable_class'
require 'json'
require 'active_support/all'
require 'pry'

require 'procreate/swatches/version'

require 'procreate/swatches/errors/invalid_format'
require 'procreate/swatches/errors/invalid_path'

require 'procreate/swatches/colors_helper'
require 'procreate/swatches/wrapper'
require 'procreate/swatches/parser'
require 'procreate/swatches/exporter'

module Procreate
  module Swatches
    SWATCHES_FILE_NAME = 'Swatches.json'

    def self.parse(file_path)
      Parser.call(file_path)
    end

    def self.export(name, colors, options = {})
      wrapper = Wrapper.new(name, colors)

      Exporter.call(wrapper, options)
    end

    class << self
      alias from_file parse
      alias to_file export
    end
  end
end
