class Module
  def method_missing(method_name, *args, &block)
    name = name.to_s.downcase
    # Attempt to match any method with the prefix of
      # find_by_ to try to print out the background color.
    if(match_data = /^find_by_()(\w*?)?$/.match name)
    # If a match from the regexp is found to equal find_by_
      # create a finder method for it
      create_finder_methods match_data[2]
      send(method_name, *args)
    end
  end
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attr|
      attr_name = attr.to_s
      method_name = "find_by_#{attr_name}"
      method = %Q{
        def #{method_name} identifier
          self.all.select{ |product| product.#{attr_name}.to_s == identifier.to_s }
        end
      }
      # define it for the class, versus instance
      self.instance_eval(method)
    end
  end
  # Standard respond_to_missing.  Thanks David :D
  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('find_by_') || super
  end
end

class Module

end
