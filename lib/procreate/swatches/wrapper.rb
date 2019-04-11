# frozen_string_literal: true

module Procreate
  module Swatches
    class Wrapper
      include ColorsHelper

      attr_accessor :name
      attr_writer :colors

      DEFAULT_SWATCHES_NAME = 'My beautiful pallete'

      def initialize(name, colors)
        @name = name.present? ? name : DEFAULT_SWATCHES_NAME

        @colors ||= []
        [*colors].each { |color| add_color(color) }
      end

      def <<(color)
        add_color(color)
      end

      alias push <<

      def pop
        @colors.pop
      end

      AVAILABLE_COLOR_FORMATS = %i[hsv hsl hex hex8 rgb name].freeze

      def colors(format: nil)
        format = format.to_sym unless format.nil?
        format = nil unless format.in?(AVAILABLE_COLOR_FORMATS)

        return @colors if format.nil?

        @colors.map do |color|
          color.send("to_#{format}")
        end
      end

      def to_json(*_args)
        [
          {
            name: @name,
            swatches: colors_to_json
          }
        ].to_json
      end

      alias to_swatches to_json
      alias to_procreate to_json

      def to_file(options = {})
        Exporter.call(self, options)
      end

      alias export to_file

      def ==(other)
        other.is_a?(self.class) && name == other.name && colors == other.colors
      end

      private

      def add_color(color)
        color = prepare_color_for_push(color)

        @colors << color unless color.nil?

        @colors
      end

      def colors_to_json
        @colors.first(SWATCHES_MAX_SIZE).map do |color|
          to_swatches_json(color)
        end
      end
    end
  end
end
