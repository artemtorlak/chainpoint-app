class ChainPoint::PrepareData
  include Callable
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
