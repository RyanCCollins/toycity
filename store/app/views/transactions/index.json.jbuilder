json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :amount, :product_id, :customer_id
  json.url transaction_url(transaction, format: :json)
end
