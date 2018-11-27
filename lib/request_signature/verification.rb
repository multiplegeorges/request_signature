module RequestSignature
  class Verification
    def initialize(signature:, secret:, time:, params:)
      @signature = signature
      @secret = secret
      @time = time
      @params = params
    end

    def verify
      return false unless valid_for_period?

      expected = RequestSignature::Request.new(params: @params, secret: @secret)
      expected.signature == @signature
    end

    def verify!
      if !valid_for_period?
        raise RequestSignature::PeriodExpiredError
      end

      if !verified?
        raise RequestSignature::InvalidSignatureError
      end

      verify
    end

    def verified?
      verify
    end

    private

    def valid_for_period?
      # Can't be older than the defined period and can't be from the future
      period = RequestSignature.configuration.validity_period
      @time >= (Time.now.to_i - period) && @time <= Time.now.to_i
    end
  end
end
