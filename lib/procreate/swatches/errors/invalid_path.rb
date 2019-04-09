# frozen_string_literal: true

module Procreate
  module Swatches
    module Errors
      class InvalidPath < StandardError
        def message
          'Invalid file path specified.'
        end
      end
    end
  end
end
