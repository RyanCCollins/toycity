require_relative "errors"

# Class product, stores products
class Product
  @@products = []
  attr_reader :title, :price, :stock

  # Initialize the product with options (title, price, stock)
  def initialize(options={})
    @title = options[:title]
    @price = options[:price]
    @stock = options[:stock]
    add_to_products # Add the product
  end

  # Returns true if the product is in stock
  def in_stock?
    @stock > 0
  end

  # Remove from the stock and raise an error if the customer
    # wants more than is available.
  def remove_stock!(quantity)
    unless quantity > @stock
      @stock = @stock - quantity
    else
      raise OutOfStockError, "#{self.title} is out of stock."
    end
  end

  # Define self under protected because they are instance methods
  def self.all
    @@products
  end

  # Instance method, searches for whether the particular product is in stock (self).
  def self.in_stock
    @@products.select { |product| product.in_stock?}
  end

  # Find a product by title.  The .find method is a shortcut for looping
    # through an array to find a match by title.
  def self.find_by_title(title)
    @@products.find {|product| product.title == title}
  end

  private
  # Private method for adding to the products array.
    # Will raise an error if the product already exists.
  def add_to_products
    unless @@products.find {|product| product.title == title}
      @@products << self
    else
      raise DuplicateProductError, "#{self.title} already exists."
    end
  end

end