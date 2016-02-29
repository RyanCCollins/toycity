class Product
    @@products = []
    attr_accessor :options
    def initialize(options={})
        @@products << self
    end
    def self.all
        @@products
    end
end