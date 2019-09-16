# frozen_string_literal: true

module Products
  module Extractor
    class Base

      attr_reader :browser

      def initialize(browser)
        @browser = browser
      end

      def get_attributes
        {
          category: category,
          dimensions: dimensions,
          rank: rank
        }.compact
      end

    end
  end
end
