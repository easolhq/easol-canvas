# frozen_string_literal: true

module Canvas
  # :documented:
  class ValidLiquidCheck < Check
    def run
      register_tags!

      liquid_files.each do |filename|
        file = File.read(filename)
        validator = Validator::Liquid.new(file)

        next if validator.validate

        validator.errors.each do |message|
          @offenses << Offense.new(
            message: "Invalid Liquid: #{filename} - \n#{message}"
          )
        end
      end
    end

    private

    def liquid_files
      Dir.glob("**/*.{html,liquid}")
    end

    def register_tag(name, klass)
      ::Liquid::Template.register_tag(name, klass)
    end

    # These are the tags that we define in the Rails app. If we add a new custom tag
    # in the Rails app, we'll need to register it here.
    def register_tags!
      register_tag("form", ::Liquid::Block)
      register_tag("product_search", ::Liquid::Block)
      register_tag("easol_badge", ::Liquid::Tag)
      register_tag("accommodation_availability", ::Liquid::Block)
      register_tag("cache", ::Liquid::Block)
      register_tag("currency_switcher", ::Liquid::Tag)
      register_tag("json", ::Liquid::Block)
      register_tag("variant_pricing", ::Liquid::Tag)
      register_tag("dynamic_package_booking_price", ::Liquid::Tag)
      register_tag("cart_timer", ::Liquid::Tag)
      register_tag("cart_timer_add_time", ::Liquid::Tag)
      register_tag("experience_slot_search", ::Liquid::Block)
      register_tag("experience_slot_calendar", ::Liquid::Block)
      register_tag("package_availability", Liquid::Block)
      register_tag("package_price", Liquid::Block)
      register_tag("input", ::Liquid::Tag)
      register_tag("label", ::Liquid::Tag)
      register_tag("package_step_product_search", ::Liquid::Block)
    end
  end
end
