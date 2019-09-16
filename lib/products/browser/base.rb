# frozen_string_literal: true

module Products
  module Browser
    class Base
      PageNotFound  = Class.new(StandardError)
      NoMoreRetries = Class.new(StandardError)
      InvalidExtId  = Class.new(StandardError)

      # ie, edge do not support headless
      BROWSERS = %i(
        chrome
        firefox
      )

      BROWSER_ERRORS = [
        Selenium::WebDriver::Error::SessionNotCreatedError,
        Selenium::WebDriver::Error::UnknownError,
        Net::ReadTimeout
      ]

      attr_reader :ext_id, :use_proxy

      def initialize(ext_id:, use_proxy: false)
        @ext_id = ext_id
        @use_proxy = use_proxy

        validate_ext_id
      end

      def get_browser(retries = 3)
        browser = new_browser

        browser.goto(product_url)

        if not_found?(browser.title)
          raise PageNotFound.new("Page Not Found")
        end

        browser
      rescue *BROWSER_ERRORS => e
        if retries.zero?
          raise NoMoreRetries.new("Out of retries :(")
        else
          if use_proxy
            ProxyFinder.remove_proxy(proxy.http)
            @raw_proxy = nil
          end

          browser&.close

          get_browser(retries - 1)
        end
      end

      private

      def new_browser
        Watir::Browser.new(user_agent, browser_settings).tap do |browser|
          # Force a 10 second wait for page to load
          browser.driver.manage.timeouts.implicit_wait = 10
        end
      end

      def browser_settings
        {
          headless: true
        }.tap do |settings|
          if use_proxy
            settings[:proxy] = proxy
          end
        end
      end

      def proxy
        Selenium::WebDriver::Proxy.new(http: raw_proxy, ssl: raw_proxy)
      end

      def raw_proxy
        @raw_proxy ||= ::ProxyFinder.get_proxy
      end

      def user_agent
        BROWSERS.sample
      end

      def validate_ext_id
        unless valid_ext_id?
          raise InvalidExtId.new("External ID provided is invalid")
        end
      end

    end
  end
end
