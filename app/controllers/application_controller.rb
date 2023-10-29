class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_action :doorkeeper_authorize!

  include Error::ErrorHandler
  include Authentication::Cookies

  def current_user
    token = ::Doorkeeper.authenticate(request)

    User.find(token.resource_owner_id)
  rescue
    nil
  end

  def assign_request_from
    params[:request_from] = @request_from
  end

  private

  def represent(representer_class, decorator: FakeDecorator,
      decorator_method: :new, status: 200)
  render json: representer_class.represent(
  decorator.public_send(decorator_method, result[:model])
  ), status: status
  end

  # Standard way of returning record invalid errors
  def record_invalid_error(contract: "default", mapper: ->(errors) { errors })
    errors_data = mapper.(result[:"result.contract.#{contract}"].errors.messages)
    defaultapi_error!(:record_invalid, "Unable to save record", 422, errors_data)
  end

  def defaultapi_error!(key = "", message = nil, code = 500, data = [])
    params, code = defaultapi_error_args(key, message, code, data)
    logger.error params
    render json: params, status: code
  end

  def defaultapi_error_from_exception
    error = result[:"result.defaultapi.rescue"].failure
    defaultapi_error!(error.key, error.message, error.code, error.data)
  end

  def not_found_error
    defaultapi_error!(:not_found, "Not found", 404)
  end

  def defaultapi_error_args(key, message = nil, code = nil, data = [])
    params = { key: key.to_s.downcase, success: false }.tap do |p|
      p[:data] = data if data.present?
    end
    [params, code]
  end

  def _run_options(options)
    options.merge(current_user: current_user)
  end

  protected

  def endpoint(operation, **options, &block)
    Trailblazer::DefaultApiEndpoint.call(operation, options, &block)
  end
end
