require "test_helper"

describe RequestSignature::Request do
  describe "initialization" do
    it "requires params" do
      error = -> { RequestSignature::Request.new(secret: 'foo') }.must_raise ArgumentError
      error.message.must_match(/missing keyword: params/)
    end

    it 'requires secret' do
      error = -> { RequestSignature::Request.new(params: { a: 'foo' }) }.must_raise ArgumentError
      error.message.must_match(/missing keyword: secret/)
    end
  end

  describe "signing" do
    before do
      RequestSignature.configure do |c|
        c.algorithm = 'SHA256'
      end
    end

    it "signs an empty request correctly" do
      request = RequestSignature::Request.new(params: {}, secret: '123abc')
      request.signature.must_equal "3e01567d3e7cbecaa0112a419dc1d24cb359d20d2a5913adef347a9a666a4fbd"
    end

    it 'signs a request with params' do
      request = RequestSignature::Request.new(params: {name: 'John'}, secret: '123abc')
      request.signature.must_equal "d120817366d4fbf7150883928e143d9657c340ee601308c26dcd380ba8bf177e"
    end

    it 'signs a request with nested params' do
      params = {
        name: 'John',
        address: {
          street1: '1 First St.',
          postal: '90210',
          number_of_residents: 3,
          resident_names: ['Amy', 'Bobby', 'Carl']
        }
      }

      request = RequestSignature::Request.new(params: params, secret: '123abc')
      request.signature.must_equal "ff0063ae9ea27c21e50ca430076ed08810fd36d6a62480c35175ff81b0494d75"
    end
  end
end