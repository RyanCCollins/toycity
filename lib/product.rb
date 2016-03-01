require_relative "errors"

class Product
  @@products = []
  attr_reader :title, :price, :stock
    
  def initialize(options={})
    @title = options[:title]
    @price = options[:price]
    @stock = options[:stock]
    add_to_products
  end
    
  def self.all
    @@products
  end
    
  def find_by_title(title)
    @@products.find {|product| product.title == title}
  end
  
  def remove_stock!(options={})

  end

    
  private

  def add_to_products
    unless product_exists?
      @@products << self
    else
      raise DuplicateProductError, "'#{self.title}'' already exists."
    end
  end
  
  def product_exists?
    return find_by_title(self.title)
  end
  
end