# frozen_string_literal: true

require 'zip'

module Procreate
  module Swatches
    class Parser
      include CallableClass
      include ColorsHelper

      attr_reader :file_path, :wrapper, :content

      def initialize(file_path)
        @file_path = file_path

        validate!
      end

      def call
        unzip
        wrap_colors
      end

      private

      def unzip
        zip_file = Zip::File.open(file_path)
        entry = zip_file.glob(SWATCHES_FILE_NAME).first
        raw_content = entry.get_input_stream.read
        @content = JSON.parse(raw_content).first
      end

      def wrap_colors
        name = content['name']
        colors = content['swatches']

        colors = colors.compact.map do |color|
          string = to_chroma_hsv(color)
          Chroma::Color.new(string)
        end

        @wrapper = Wrapper.new(name, colors)
      end

      SWATCHES_FILE_REGEXP = /\.swatches\z/.freeze

      def validate!
        unless file_path.present? && File.exist?(file_path) && File.file?(file_path)
          raise(Errors::InvalidPath)
        end

        raise(Errors::InvalidFormat) unless file_path.match(SWATCHES_FILE_REGEXP).present?
      end
    end
  end
end
