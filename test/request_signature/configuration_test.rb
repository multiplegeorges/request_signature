require "test_helper"

describe RequestSignature::Configuration do
  describe "defaults" do
    subject { RequestSignature::Configuration.new }

    it 'defaults to SHA256' do
      subject.algorithm.must_equal 'SHA256'
    end

    it 'defaults to 1 minute validity period' do
      subject.validity_period.must_equal 60
    end
  end
end