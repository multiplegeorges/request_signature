$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "request_signature"
require "minitest/autorun"

# Frozen time!
# Needed for test hash signatures to work.
class Time
  def self.now
    Time.at(1543346191)
  end
end
