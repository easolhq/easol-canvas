# frozen_string_literal: true

# We need to require this file t ensure it is loaded first
require_relative "menu_schema"

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a schema for a footer. For now the logic is exactly the
    # same as the menu schema.
    #
    # Example:
    # {
    #   "max_item_levels" => 2,
    #   "supports_open_new_tab" => "true",
    #   "attributes" => {
    #      "text_color" => {
    #        "type" => "color"
    #      },
    #      "background_color" => {
    #        "type" => "color"
    #      }
    #   },
    #   "layout" => [
    #     {
    #       "type" => "tab",
    #       "label" => "Content",
    #       "elements" => [
    #         "text_color",
    #         "background_color"
    #       ]
    #     }
    #   ]
    # }
    class FooterSchema < MenuSchema; end
  end
end
