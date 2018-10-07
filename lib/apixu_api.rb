class ApixuApi
  def self.temperature_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    temp = response.parsed_response["current"]["temp_c"]
    temp
  end

  def self.condition_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    condition = response.parsed_response["current"]["condition"]["text"]
    condition
  end

  def self.wind_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    wind = response.parsed_response["current"]["wind_kph"]
    direction = response.parsed_response["current"]["wind_dir"]

    Array[wind, direction]
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end
end
