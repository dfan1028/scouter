module Products
  module Errors
    class Handler

      RESCUABLE_ERRORS = [
        Products::Browser::Base::PageNotFound,
        Products::Browser::Base::NoMoreRetries,
        Products::Browser::Base::InvalidExtId,
        Locksmith::Locked
      ]

      attr_reader :product

      def initialize(product)
        @product = product
      end

      def process(error)
        unlock

        unless RESCUABLE_ERRORS.include?(error.class)
          raise error
        end

        product.tap do |prod|
          prod.errors.add(:ext_id, error.message)
        end
      end

      private

      def unlock
        Locksmith.unlock(
          lock_key(product)
        )
      end

      def lock_key(product)
        Products::Manager.lock_key(product)
      end

    end
  end
end
