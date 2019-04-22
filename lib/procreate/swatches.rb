# frozen_string_literal: true

require 'chroma'
require 'callable_class'
require 'json'
require 'active_support/all'

require 'procreate/swatches/version'

require 'procreate/swatches/errors/invalid_format'
require 'procreate/swatches/errors/invalid_path'

require 'procreate/swatches/colors_helper'
require 'procreate/swatches/wrapper'
require 'procreate/swatches/parser'
require 'procreate/swatches/exporter'

module Procreate
  module Swatches
    # Internal name of the +.swatches+ file.
    # Used for both parsing and exporting +.swatches+ files.
    SWATCHES_FILE_NAME = 'Swatches.json'

    #
    # Parse a +.swatches+ file from the provided file path
    #
    # @param [String] file_path A file path to the +.swatches+ file
    #
    # @return [Procreate::Swatches::Wrapper] wrapper A wrapper instance to be further manipulated
    #
    def self.parse(file_path)
      Parser.call(file_path)
    end

    #
    # Export an array of colors to a +.swatches+ file, with the possibility to provide a custom palette name.
    #
    # @param [String] name Preferred name for the exported +.swatches+ file palette. Visible instance the Procreate app.
    # @param [Array<String, Chroma::Color>] colors An array of valid color strings or {Chroma::Color} instances
    # @param [Hash] options Options for exporting the wrapper
    # @option options [String] :export_directory ('Dir.pwd') The export directory for the +.swatches+ file
    # @option options [String] :file_name ('Wrapper#name') Custom file name for the exported +.swatches+ file. If none is provided, the +name+ of the +wrapper+ instance is used
    #
    # @return [String] swatches_path Path of the exported +.swatches+ file
    #
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
