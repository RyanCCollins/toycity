require_relative "errors"

class Customer
  attr_reader :name
  @@customers = []


  def initialize(options = {})
    @name = options[:name]
    add_to_customers
  end

  def purchase(product, options = {:quantity => 1}) # Set default quantity to 1
    Transaction.new(self, product, options)
  end

  protected

  def self.find_by_name(name)
    @@customers.find {|customer| customer.name == name}
  end

  def self.all
    @@customers # Return the customer array
  end

  private

  def add_to_customers
    if @@customers.find {|customer| customer.name == self.name }
      raise DuplicateNameError, "#{self.name} is already a customer."
    else
      @@customers << self
    end
  end
end