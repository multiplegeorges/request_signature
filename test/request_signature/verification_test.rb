describe RequestSignature::Request do
  let(:keys) {
    # { key: secret }
    { a: '123abc', b: 'xyz987' }
  }

  describe 'signature verification' do
    before do
      RequestSignature.configure do |c|
        c.algorithm = 'SHA256'
      end
    end

    it 'verifies a valid request' do
      params = { name: 'John' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i,
        params: params
      )

      verification.verify!.must_equal true
    end

    it 'rejects a request signed with a different secret' do
      params = { name: 'John' }
      request = RequestSignature::Request.new(params: params, secret: 'wrong-key')

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i,
        params: params
      )

      verification.verify.must_equal false
    end

    it 'rejects a request signed with different params' do
      params = { name: 'Mary' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i,
        params: { name: 'John' } # Different params
      )

      verification.verify.must_equal false
    end
  end

  describe 'validity period' do
    it 'verifies valid requests within the validity period' do
      params = { name: 'John' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i - 30,
        params: params
      )

      verification.verify.must_equal true
    end

    it 'rejects a request that is too old' do
      params = { name: 'John' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i - 300, # 5 minutes is too long ago
        params: params
      )

      verification.verify.must_equal false
    end

    it 'rejects a request from the FUTURE!' do
      params = { name: 'John' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i + 300, # THE FUTURE!
        params: params
      )

      verification.verify.must_equal false
    end

    it 'accepts params in a different order' do
      params = { a: 'A', b: 'B', c: 'C' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i - 30,
        params: { c: 'C', b: 'B', a: 'A' }
      )

      verification.verify.must_equal true
    end

    it 'accepts params in a different order and deeply nested' do
      params = { a: 'A', b: { z: 3, x: { q: 4, e: 5 } }, c: 'C' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i - 30,
        params: params = { a: 'A', b: { x: { e: 5, q: 4 }, z: 3 }, c: 'C' }
      )

      verification.verify.must_equal true
    end

    it 'accepts deeply nested params with string keys' do
      params = { 'a': 'A', 'b': { 'z': 3, 'x': { 'q': 4, 'e': 5 } }, 'c': 'C' }
      request = RequestSignature::Request.new(params: params, secret: keys[:a])

      verification = RequestSignature::Verification.new(
        signature: request.signature,
        secret: keys[:a],
        time: Time.now.to_i - 30,
        params: params = { a: 'A', b: { x: { e: 5, q: 4 }, z: 3 }, c: 'C' }
      )

      verification.verify.must_equal true
    end
  end
end
