require_relative "errors"

class Customer
  attr_reader :name
  @@customers = []

  def initialize(options = {})
    @name = options[:name]
    add_to_customers
  end

  # Convenience to create a new pruchase transaction with default quantity of 1.
  def purchase(product, options = {:quantity => 1}) # Set default quantity to 1
    Transaction.new(self, product, options)
  end

  # Class method for finding customers by name.
    # the find method returns the first match based on the given condition.
  def self.find_by_name(name)
    @@customers.find {|customer| customer.name == name}
  end

  def self.all
    @@customers # Return the customer array
  end

  private

  # If this is a new customer, push onto customers array.
    # Otherwise, return a duplicate name error.
  def add_to_customers
    if @@customers.find {|customer| customer.name == self.name }
      raise DuplicateNameError, "#{self.name} is already a customer."
    else
      @@customers << self
    end
  end
end