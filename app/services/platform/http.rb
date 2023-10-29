module Platform
  class Http
    class << self
      def get(url, headers = {})
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        request = Net::HTTP::Get.new(uri)
        headers.each { |key, value| request[key] = value }
        response = http.request(request)

        JSON.parse(response.body)
      end
    end
  end
end