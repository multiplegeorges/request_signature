require "test_helper"

describe RequestSignature do
  describe 'configuration' do
    it 'configures the algorithm' do
      RequestSignature.configure do |c|
        c.algorithm = 'SHA1'
      end

      RequestSignature.configuration.algorithm.must_equal 'SHA1'
    end
  end
end
