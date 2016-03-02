require_relative "errors"
require_relative "bank"

class Transaction
  attr_reader :customer, :product, :id, :sale_amount

  @@id_counter = 0
  @@transactions = []

  def initialize(customer, product, options = {quantity: 1, print_receipt: true})
    @customer = customer
    @product = product

    # Remove stock from the product if possible.
      # Will raise an out of stock error if quantity exceeds stock.
    product.remove_stock!(options[:quantity])
    @id = increment_transaction_id

    # Calculate the amount of the sale (quantity times price).
      # We may want to calculate sales tax in the next version.
    @sale_amount = options[:quantity] * @product.price
    add_to_transactions

    #Print a receipt as long as the option is on.
    unless options[:print_receipt] == false
      print_receipt(@id)
    end
  end

  # Class method for finding by ID
  def self.find(id)
    # Find a transaction by id using the .find iterator.
      # Will return the first result.
    @@transactions.find {|transaction| transaction.id == id }
  end

  # Class method for returning all transactions.
  def self.all
    @@transactions
  end

  # Print a receipt for the transaction by ID.
    # Raise an error if there is no transaction to be found.
  def print_receipt(id)
    transaction = @@transactions.find {|transaction| transaction.id == id }
    unless transaction == nil
      puts ""
      puts "Receipt for transaction #{transaction.id}"
      puts "---------------------"
      puts "Product Bought: #{transaction.product.title}"
      puts "Customer Name: #{transaction.customer.name}"
      puts "Sale Price: #{transaction.product.price}"
      puts ""
    else
      raise UnkownTransactionError, "Unknown transaction of ID: #{id}"
    end
  end

  private

  # Increment the transaction id counter.
  def increment_transaction_id
    @@id_counter += 1
  end

  # Add to the transactions array.
  def add_to_transactions
    @@transactions << self
  end
end