require_relative 'find_by'
require_relative 'errors'
require_relative '../data/schema'
require 'csv'


class Udacidata
  @@products = []

  class << self
    include Schema

    def create(attributes = nil)
      product = self.new(attributes)
      add_to_database product
      @@products << product
      product
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
      all.take n
    end

    # Returns the last n product records, where n is number of records to return
    # @params n, defaults to 1
    # @return [Product], of n length containing last items of @@products array
    def last(n=1)
      all.last n
    end

    # Find and return a product by id given.  Raise the ProductNotFoundError if not found.
    # @params id
    # @return Product, or nil if no product exists at the id
    def find(id)
      product = all.select{ |product| product.id == id }
      if !product
        raise ProductNotFoundError, "Product not found"
      else
        produt
      end
    end

    # Remove the product with id given from the @@products array
    # @params id
    # @return Product deleted or nil
    def destroy(id)
      product = find(id)
      all.delete product if product
    end

    def where(*args)
    end

    def update(*args)
    end
    def add_to_database *products
      CSV.open file_path, "ab" do |csv|
        products.each do |product|
          csv << [product.id, product.brand, product.name, product.price]
        end
      end
    end
    def remove_from_database id

    end
  end
end
