module Gt2::Api::Errors
  class Error < StandardError; end

  class NotFoundError < Error; end
end