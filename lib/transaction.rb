require_relative "errors"

class Transaction
  attr_reader :customer, :product, :id

  @@transaction_ids = 0
  @@transactions = []

  def initialize(customer, product, options = {:quantity => 1})
    @customer = customer
    @product = product
    product.remove_stock(options)
    @id = self.increment_transaction_id
  end

  def self.find(id)
    # Find a transaction by id
    @@transactions.find {|transaction| transaction.id == id }
  end

  private

  def self.increment_transaction_id
    @@transaction_ids += 1
  end

  def add_to_transactions
    @@transactions << self
  end
end