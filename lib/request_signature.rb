require "request_signature/configuration"
require "request_signature/request"
require "request_signature/verification"


module RequestSignature
  VERSION = "1.0.0"

  class InvalidSignatureError < StandardError; end
  class PeriodExpiredError < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration if block_given?
  end
end
