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

# Set defaults in case the user forgot to.
RequestSignature.configure

# Some ugliness to easily sort complex params hashes.
# Keys must all be symbols or all string. No mixing.
# Credit: http://bdunagan.com/2011/10/23/ruby-tip-sort-a-hash-recursively
class Hash
  def deep_sort(&block)
    self.class[
      self.each do |k,v|
        self[k] = v.deep_sort(&block) if v.class == Hash
        self[k] = v.collect {|a| a.deep_sort(&block) if a.class == Hash } if v.class == Array
      end.sort(&block)
    ]
  end
end
