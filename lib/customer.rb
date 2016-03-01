class Customer
  attr_reader :name
  @@customers = []
   
   
  def initialize(options = {})
    @name = options[:name]
  end
  
  def self.find_by_name
    @@customers.find {|customer| customer.name == name}
  end
  
  def self.all
    @@customers # Return the customer array
  end
  
  def self.find_by_name(name)
    @@customers.find {|customer| customer.name == name} 
  end
  
  def purchase(product, options)
    
  end
  private 
end