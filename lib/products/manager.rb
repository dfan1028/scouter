# frozen_string_literal: true

module Products
  class Manager

    attr_reader :product, :use_proxy

    class << self
      def lock_key(product)
        "product:#{product.ext_id}:#{product.platform}"
      end
    end

    def initialize(options = {})
      @product = Product.find_or_initialize_by(ext_id: options[:ext_id])
      @use_proxy = options[:use_proxy]
    end

    def create_or_update
      # Each instance of fetching a product is locked because we
      # don't need more than one to run at a time
      Locksmith.lock(lock_key) do
        assign_attributes

        product.save if save?(product)
      end

      product
    rescue => e
      error_handler.process(e)
    end

    def lock_key
      self.class.lock_key(product)
    end

    private

    def assign_attributes
      attributes = extractor.get_attributes
      product.assign_attributes(attributes)
    end

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
