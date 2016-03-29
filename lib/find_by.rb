class Module
  # Method missing is called when a method does not exist.
  # In this case, we are looking for a particular find_by_(n) prefix
  # Where (n) is an attribute we are looking for, such as name or ID
  # Will create a finder method for the attribute (see create_finder_methods)
  # @param method_name, array of args and a block
  def method_missing(method_name, *args, &block)
    name = method_name.to_s.downcase
    # Attempt to match any method with the prefix of
      # find_by_
    if(match_data = /^find_by_()(\w*?)?$/.match name)
    # If a match from the regexp is found to equal find_by_
      # create a finder method for it
      create_finder_methods match_data[2]
      send(method_name, *args)
    else
      super(method_name, *args)
    end
  end

  # Creates a finder method for basically any find_by_ + attribute method
  # in an effort to facilitate the creation of finder methods for any attribute of the Udacidata Classes
  # @param *attributes, An array of attributes
  def create_finder_methods(*attributes)
    attributes.each do |attr|
      attr_name = attr.to_s
      method_name = "find_by_#{attr_name}"
      method = %Q{
        def #{method_name}(identifier)
          self.all.select{ |product| product.#{attr_name}.to_s == identifier.to_s }.first
        end
      }
      # define it for the class, versus instance
      self.instance_eval(method)
    end
  end
  # Standard respond_to_missing.
  # Will allow you to call ModuleName.respond_to? find_by_id
  # Will return true for any finder methods.
  #
  # EXAMPLE:
  # Product.respond_to?("find_by_id")
  #  => true
  # @param method_name as a string
  # @return Boolean whether the class responds to the method called.
  def respond_to_missing?(method_name, include_private = false)
    name = method_name.to_s.downcase
    match = /^find_by_()(\w*?)?$/.match(name)
    if match
      self.new.respond_to? match[2]  || super
    else
      super
    end
  end
end
