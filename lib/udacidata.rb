require_relative 'find_by'
require_relative 'errors'
require_relative '../data/schema'
require 'csv'


class Udacidata
  @@products = []

  def initialize

  end

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
      @@products = load_from_database
      @@products
    end

    # Find the first n product records, where n is number of records to return
    # @params n, optional number of records to return
    # @return [Product], of n length containing last items of @@products array, or Product if n == 1
    def first(n=1)
      n > 1 ? all.first(n) : all.first
    end

    # Returns the last n product records, where n is number of records to return
    # @params n, defaults to 1
    # @return [Product], of n length containing last items of @@products array, or Product if n == 1
    def last(n=1)
      n > 1 ? all.last(n) : all.last
    end

    # Find and return a product by id given.  Raise the ProductNotFoundError if not found.
    # @params id
    # @return Product, or nil if no product exists at the id
    def find(id)
      products = all.select{ |p| p.id == id }
      if !products
        raise ProductNotFoundError, "Product not found"
      else
        products.first
      end
    end

    # Remove the product with id given from the @@products array
    # @params id
    # @return Product deleted or nil
    def destroy(id)
      product_to_delete = self.find id
      unless product_to_delete == nil
        remove_from_database id
        product_to_delete
      else
        raise ProductNotFoundError, "Product not found with id of #{id}"
      end
    end

    def where(options = {})
      selected_products = []
      all.each do |product|
        options.each do |key, value|
          if product.send(key) == value
            selected_products << product
          end
        end
      end
      selected_products
    end

    def update(options = {})
      options.each do |key, value|
        self.send("#{key}=value")
      end
      add_to_database all
    end

    def load_from_database
        products = []
        CSV.foreach(file_path, {:headers => :first_row}) do |row|
            products << Product.new(id: row[0], brand: row[1],
                                                name: row[2], price: row[3])
        end
        products
    end

    def add_to_database *products
      CSV.open file_path, "ab" do |csv|
        products.each do |product|
          csv << [product.id, product.brand, product.name, product.price]
        end
      end
    end

    def remove_from_database id
      table = CSV.table(file_path)
      table.delete_if do |row|
        row[:id] == id
      end
      File.open(file_path, 'w') do |f|
        f.write(table.to_csv)
      end
    end
  end
end
