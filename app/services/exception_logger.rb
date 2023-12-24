class ExceptionLogger
  class << self
    def error(exception, *args)
      new(exception, *args).tap do |exception_logger|
        exception_logger.push_to_logger(:error)
      end
    end
  end

  attr_reader :exception, :custom_message, :extra

  def initialize(exception, *args)
    @exception = exception
    @custom_message, @extra = extract_arguments(args)
  end

  def push_to_logger(level, *tags)
    logger.tagged(tags) do
      logger.public_send(level, exception)
    end
  end

  private

  def extract_arguments(args)
    custom_message = nil
    extra = nil

    args.each do |arg|
      if arg.is_a?(String)
        custom_message = arg
      elsif arg.is_a?(Hash)
        extra = arg
      end
    end

    [custom_message, extra]
  end

  def logger
    Rails.logger
  end

  def message
    custom_message.present? ? custom_message : exception.message
  end
end
