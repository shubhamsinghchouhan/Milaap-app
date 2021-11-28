class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  def initialize(options)
    @options = options
  end
end