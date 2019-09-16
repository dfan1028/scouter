# frozen_string_literal: true

module Products
  class Manager

    attr_reader :product, :use_proxy

    def initialize(options = {})
      @product = Product.find_or_initialize_by(ext_id: options[:ext_id])
      @use_proxy = options[:use_proxy]
    end

    def create_or_update
      product.tap do |prod|
        attributes = extractor.get_attributes
        prod.assign_attributes(attributes)
        prod.save if save?(prod)
      end
    rescue => e
      error_handler.process(e)
    end

    private

    def save?(product)
      product.changed? || !product.persisted?
    end

    def browser
      @browser ||= browser_klass.new(ext_id: product.ext_id, use_proxy: use_proxy).get_browser
    end

    def extractor
      @extractor ||= extractor_klass.new(browser)
    end

    def browser_klass
      "Products::Browser::#{product.platform.capitalize}".constantize
    end

    def extractor_klass
      "Products::Extractor::#{product.platform.capitalize}".constantize
    end

    def error_handler
      @error_handler ||= Errors::Handler.new(product)
    end

  end
end
