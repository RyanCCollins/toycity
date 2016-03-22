require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@products = []

  # Initializes a new database object with options
  # @params options = {}, { :id => 1, : :name = "Some Name", :brand => "Some Brand
  #                                                          :price => 29.99 }
  # ======== Example
  # Udacidata.new(id: 1, name: "Product Name", brand: "Lego", price: 29.99)
  def initialize(options = {})
    @id = id
    @name = options[:name]
    @brand = options[:brand]
    @price = options[:price]
  end

  class << self
    def create(attributes = nil)
    end
    # Returns all product
    # @return [Product] an array of all products
    # Example
    def all
      @@products
    end

    # Find the first n product records, where n is number of records to return
    # @params n, optional number of records to return
    # @return
    def first(n=1)
      all.first n
    end

    # Returns the last n product records, where n is number of records to return
    # @params n, defaults to 1
    # @return [Product], of n length containing last items of @@products array
    def last(n=1)
      all.last n
    end

    # Find and return a product by id given
    # @params id
    # @return Product, or nil if no product exists at the id
    def find(id)
      all.select{ |product| product.id == id }
    end

    # Remove the product with id given from the @@products array
    # @params id
    # @return Product deleted or nil
    def destroy(id)
      all.delete{ |product| product.id == id }
    end

    # Define methods for find_by_#{attribute}
    #
    # Example
    # # Return the Product where name matches an existing product, or nil if no match
    # # @params name
    # # @return Product, or nil if no product matches by name
    # def find_by_name(name)
    #
    # end
    ["name", "brand", "price", "id"].each do |method|
      define_method "find_by_#{method}" do
         all.find { |product| product.#{method} == method }
      end
    end

    def where(*args)
    end

    def update(*args)
    end

  end
end
