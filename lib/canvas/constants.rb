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
      date
    ].freeze

    # These are types where the value is stored as a primitive type, e.g. string, integer.
    # As opposed to values such as product IDs, color hashes, etc.
    # This constant is currently used to determine whether it is safe to preserve
    # a value when a variable changes type.
    TYPES_WITH_PRIMITIVE_VALUE = %w[
      boolean
      number
      radio
      range
      select
      string
      text
    ]
  end
end
