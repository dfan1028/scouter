module Products
  module Errors
    NoMoreRetries = Class.new(StandardError)
    PageNotFound = Class.new(StandardError)
  end
end
