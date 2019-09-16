# frozen_string_literal: true

module Products
  module Browser
    class Amazon < Base

      def product_url
        "https://www.amazon.com/dp/#{ext_id}"
      end

      def not_found?(title)
        !!(title =~ /Page Not Found/)
      end

      def valid_ext_id?
        !!(ext_id =~ /^[a-zA-Z0-9]*$/)
      end

    end
  end
end
