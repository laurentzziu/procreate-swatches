# frozen_string_literal: true

module Procreate
  module Swatches
    class Wrapper
      include ColorsHelper

      attr_accessor :name, :colors

      DEFAULT_SWATCHES_NAME = 'My beautiful pallete'

      def initialize(name, colors)
        @name = name.present? ? name : DEFAULT_SWATCHES_NAME

        @colors ||= []
        [*colors].each { |color| add_color(color) }

        self
      end

      def <<(color)
        add_color(color)
      end

      alias push <<

      def pop
        @colors.pop
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

      def ==(object)
        object.is_a?(self.class) && name == object.name && colors == object.colors
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
