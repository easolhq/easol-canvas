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
      boolean
      color
      image
      link
      number
      page
      post
      product
      radio
      range
      select
      string
      text
      variant
    ].freeze
  end
end
