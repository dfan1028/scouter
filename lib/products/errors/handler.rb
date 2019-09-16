module Products
  module Errors
    class Handler

      attr_reader :product

      def initialize(product)
        @product = product
      end

      def process(e)
        product.tap do |prod|
          prod.errors.add(:ext_id, e.message)
        end
      end

    end
  end
end
