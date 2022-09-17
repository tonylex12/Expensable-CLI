require "httparty"

module Services
  class Categories
    include HTTParty

    base_uri "https://expensable-api.herokuapp.com"

    def self.index(token)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }
      response = get("/categories", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.create(token, category_data)
      options = {
        body: category_data.to_json,
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        }
      }
      response = post("/categories", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.update(token, id, category_data)
      options = {
        body: category_data.to_json,
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        }
      }

      response = patch("/categories/#{id}", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.destroy(token, id)
      options = {
        headers: {
          Authorization: "Token token=#{token}"
        }
      }

      response = delete("/categories/#{id}", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true) unless response.body.nil?
    end
  end
end
