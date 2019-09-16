# frozen_string_literal: true

module Products
  module Extractor
    class Amazon < Base

      DETAIL_SELECTORS = %w(
        #prodDetails
        #detail-bullets
        .prodDetTable
        #detailBullets
      )

      private

      def category
        text = details&.match(/^#\d.+/)&.to_s

        if text.present?
          text.split(" in ").last.strip
        end
      end

      def dimensions
        text = details&.match(/.?Dimensions.+/)&.to_s

        if text.present?
          text.gsub(":", "").gsub("Dimensions", "").strip
        end
      end

      def rank
        text = details&.match(/^#\d+/)&.to_s

        if text.present?
          text.gsub("#", "").strip
        end
      end

      def details
        return @details if defined?(@details)

        found = nil

        DETAIL_SELECTORS.each do |selector|
          element = browser.element(css: selector)

          if element.exists?
            found = element.text
            break
          end
        end

        # We grabbed the html we wanted and don't need the browser anymore
        browser&.close

        @details = found
      end

    end
  end
end
