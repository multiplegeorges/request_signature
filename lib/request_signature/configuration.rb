module RequestSignature
  class Configuration
    attr_accessor :algorithm
    attr_accessor :validity_period
    attr_accessor :sort_params

    def initialize
      @algorithm = 'SHA256'
      @validity_period = 60 # 1 Minute
      @sort_params = true
    end
  end
end