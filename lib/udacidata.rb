require_relative 'find_by'
require_relative 'errors'
require_relative '../data/schema'
require 'csv'


class Udacidata
  @@products = []

  # Updates an existing product, saving it to the end of the DB
  # @param options hash that contains key value pairs for updating a product
  # @return self an instance of self with updated attributes
  def update(options = {})
    old_id = self.id # Store the old id in case you are updating the ID value
    needs_update = false
    options.each do |key, value|
      if self.respond_to? key
        self.send("#{key}=", value)
        needs_update = true
      end
    end
    if needs_update
      self.class.destroy old_id
      self.class.add_to_database self
    end
    self
  end

  class << self
    # Include the Schema module in order to get the file_path
    include Schema

    # Creates a new product and saves to the db
    # @param attributes hash defaults to nil
    # @return Product, freshly minted Product instance
    def create(attributes = nil)
      product = self.new(attributes)
      add_to_database product
      @@products << product
      product
    end

    # Returns all products from DB.
    # @return [Product] an array of all products
    def all
      @@products = load_from_database
      @@products
    end

    # Find the first n product records, where n is number of records to return
    # @param n optional number of records to return. Defaults to 1
    # @return Product, [Product] of n length containing first items of @@products array, or Product if n == 1
    def first(n=1)
      n > 1 ? all.first(n) : all.first
    end

    # Returns the last n product records, where n is number of records to return
    # @param n optional number of records to return. Defaults to 1
    # @return Product, [Product] of n length containing last items of @@products array, or Product if n == 1
    def last(n=1)
      n > 1 ? all.last(n) : all.last
    end

    # Find and return a product by id given.  Raise the ProductNotFoundError if not found.
    # @param id of the record to find in the DB
    # @return [Product, nil] A Product instance or nil if no product exists at the id
    def find(id)
      product = all.select{ |p| p.id == id }.first
      if product == nil
        raise ProductNotFoundError, "Product not found with id of #{id}"
      else
        product
      end
    end

    # Remove the product with id given from the @@products array
    # @param id of item to find in the database
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

    # Update any item where the given hash returns an item
    # @param option = {}, containing search parameters for attributes defined in Product
    # @return [Product] return an array of Product objects that match a given brand or product name.
    def where(options = {})
      selected_products = []
      all.each do |product|
        options.each do |key, value|
          # Compares the value to_s, so this only works with exact
            # price values and exact matches, case and spelling.
          if product.send(key).to_s == value.to_s
            selected_products << product
          end
        end
      end
      selected_products
    end


    # Loads all items from database sorted by ID
    # @return [Product, nil] return an array of Product objects that contains all items
      # from DB sorted by ID.
    def load_from_database
        products = []
        CSV.foreach(file_path, {:headers => :first_row}) do |row|
            products << Product.new(id: row[0], brand: row[1],
                                                name: row[2], price: row[3])
        end
        # Insure that our products are sorted by ID when loaded
        products.sort{ |a, b| a.id <=> b.id }
    end

    # Add one or more items to the database
    # @param *products one or more products in array format
    def add_to_database *products
      CSV.open file_path, "ab" do |csv|
        products.each do |product|
          csv << [product.id, product.brand, product.name, product.price]
        end
      end
    end

    # Remove an item from the db based on ID.
    # @param id of item to remove
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
