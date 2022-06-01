# frozen_string_literal: true

# :documented:
# This file is used to define globally accessible constants.
module Canvas
  module Constants
    COLOR_PALETTE_VALUES = %w[
      primary
      secondary
      body-bg
      body-color
    ].freeze

    PRIMITIVE_TYPES = %w[
      image
      product
      post
      page
      link
      text
      string
      boolean
      number
      color
      select
      range
      radio
      variant
    ].freeze
  end
end
