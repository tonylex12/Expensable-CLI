module Services
  class Transactions
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
    
    def self.create(token, id, transaction_data)
      options = {
        body: transaction_data.to_json,
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        }
      }

      response = post("/categories/#{id}/transactions", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.update(token, c_id, t_id, transaction_data)
      options = {
        body: transaction_data.to_json,
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        }
      }

      response = patch("/categories/#{c_id}/transactions/#{t_id}", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true)
    end
    
    def self.destroy(token, c_id, t_id)
      options = {
        headers: {
          Authorization: "Token token=#{token}"
        }
      }

      response = delete("/categories/#{c_id}/transactions/#{t_id}", options)
      raise ResponseError.new(response) unless response.success?
      JSON.parse(response.body, symbolize_names: true) unless response.body.nil?
    end

  end
end