# frozen_string_literal: true

module Procreate
  module Swatches
    module ColorsHelper
      SWATCHES_MAX_SIZE = 30
      SWATCHES_ALPHA = 1
      SWATCHES_COLOR_SPACE = 0
      SELECTED_KEYS = %w[hue saturation brightness].freeze

      def to_swatches_json(color)
        hsv_color = color.hsv

        hue = hsv_color.h / 360
        saturation = hsv_color.s
        brightness = hsv_color.v

        to_color_json(hue, saturation, brightness)
      end

      def to_color_json(hue, saturation, brightness)
        {
          hue: hue,
          saturation: saturation,
          brightness: brightness,
          alpha: SWATCHES_ALPHA,
          colorSpace: SWATCHES_COLOR_SPACE
        }
      end

      def to_chroma_hsv(color)
        hue, saturation, brightness = *color.values_at(*SELECTED_KEYS)
        hue, saturation, brightness = *[hue * 360, saturation * 100, brightness * 100].map(&:round)

        +"hsv(#{hue}, #{saturation}%, #{brightness}%)"
      end

      def prepare_color_for_push(color)
        return color if color.is_a?(Chroma::Color)

        begin
          Chroma::Color.new(color.dup)
        rescue Chroma::Errors::UnrecognizedColor
          nil
        end
      end
    end
  end
end
