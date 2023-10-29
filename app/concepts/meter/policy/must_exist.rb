class Meter::Policy::MustExist
  extend Uber::Callable

  pattr_initialize :params

  def self.call(_options, params:, **)
   new(params).meter_exist?
  end

  def call
    meter_exist?
  end

  def meter_exist?
    return true if meter

    false
  rescue
    false
  end

  private

  def url
    "#{Settings.meter.openbolt_uri}/v1/meters/#{params[:meter_id]}"
  end

  def headers
    { "x-api-key" => Settings.meter.openbolt_api_key }
  end

  def meter
    Platform::Http.get(url, headers)
  end
end
