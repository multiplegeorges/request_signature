require 'json'
require 'openssl'

module RequestSignature
  class Request
    attr_reader :time
    attr_reader :params

    def initialize(params:, secret:)
      @params = RequestSignature.configuration.sort_params ? params.deep_sort : params
      @secret = secret
      @time = Time.now.to_i
    end

    def signature
      input = JSON.generate("#{@time}:#{@params}")
      algo = RequestSignature.configuration.algorithm
      OpenSSL::HMAC.hexdigest(algo, @secret, input)
    end

    def headers
      {
        'X-Request-Signature': signature,
        'X-Signature-Time': @time,
      }
    end
  end
end