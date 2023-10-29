module ApiError::DefaultApiError
  class Base < StandardError
    attr_reader :error, :key, :code

    def initialize(error, options = {})
      @error   = error
      @key     = options.fetch(:key, :unknown)
      @message = options.fetch(:message, error.message)
      @code    = options.fetch(:code, 500)
      @data    = error.data || options.fetch(:data, default_data)
    end

    def to_s
      message
    end

    def message
      @message.is_a?(Proc) ? @message.call(self) : @message
    end

    def data
      @data.is_a?(Proc) ? @data.call(self) : @data
    end

    private

    def hide_backtrace?
      Rails.env.production? || Rails.env.sandbox?
    end

    def default_data
      return [] if hide_backtrace?

      Rails.backtrace_cleaner.clean(error.try(:backtrace) || [])
    end
  end
end
