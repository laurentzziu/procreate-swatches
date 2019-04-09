# frozen_string_literal: true

module Procreate
  module Swatches
    module Errors
      class InvalidFormat < StandardError
        def message
          'Invalid file format specified. Accepted file format: `.swatches`.'
        end
      end
    end
  end
end
