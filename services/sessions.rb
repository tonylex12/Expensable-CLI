require "httparty"
require "json"

module Services
  class Sessions
  include HTTParty

  base_uri "https://expensable-api.herokuapp.com"

    def self.login(credentials)

      options = {
        body: credentials.to_json,
        headers: {
          "Content-Type": "application/json"
        }
      }

      response = post("/login", options)

      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.signup(user_data)
      raise ResponseError.new("Invalid format") unless user_data[:email].match(/^\w+@\w+\.\w{2,3}$/)
      raise ResponseError.new("Minimum 6 characters") unless user_data[:password].match(/.{6,}/)
      if user_data[:phone] && !user_data[:phone].match(/(\+51\s)?\d{9}/)
        raise ResponseError.new("Required format: +51 111222333 or 111222333") 
      end
      options = {
        body: user_data.to_json,
        headers: {
          "Content-Type": "application/json"
        }
      }

      response = post("/signup", options)

      raise ResponseError.new(response) unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    rescue StandardError => e
      puts e.message
    end
  end
end