module CustomTokenExtractor
  def self.call(request)
    return request.authorization.split(' ').last if request.authorization

    return request.cookie_jar.signed[:defaultapi_access_token]
  end
end