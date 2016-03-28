module Analyzable
  # count_by_brand(*brands)
  # @params [Product]
  # @return { :brand_name => count }
  #
  # ====== Example
  # Analyzable::count_by_brand(Product.all)
  # #=> {"Lego"=>3, "Fisher-Price"=>2, "Nintendo"=>1, "Crayola"=>2, "Hasbro"=>2}
  def count_by_brand(products)
    #Create an array of brands
    brands = products.map { |p| p.brand }
    # Inject a hash with the count for each particular brand
    brands.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
    brands
  end
  # count_by_name(*names)
  # @params [Product]
  # @return { :product_name => count }
  #
  #======= Example
  # Analyzable::count_by_name(Product.all)
  # #=> {"Sleek Linen Watch"=>2,
  # "Heavy Duty Iron Bottle"=>5,
  # "Lightweight Paper Table"=>1,
  # "Heavy Duty Wool Shirt"=>1,
  # "Enormous Paper Computer"=>1}
  def count_by_name(products)
    #Create an array of brands
    names = products.map { |p| p.name }
    # Inject a hash with the count for each particular brand
    names.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
    names
  end

  # average_price, takes an array of products and returns
  # the average price of all of the products
  # @params [Product]
  # @return average_price
  def average_price products
    # Create a new array with the prices to floart
    prices = products.map { |p| p.price.to_f  }
    avg = prices.inject(:+).to_f / prices.size
    avg.round(2)
  end

  def inventory_output *args
    output = []
    args.each do |a, b|
      output << " - #{a}: #{b}"
    end
    output.join('\n')
  end

  # print_report
  # @params [Product]
  # @return Report: average price, counts by brand, and counts by product name.
  #
  #====== Example
  # Analyzable::print_report(Product.all)
  #=> Average Price: $51.6
  # Inventory by Brand:
  # - Hasbro: 5
  # - Fisher-Price: 1
  # - Crayola: 2
  # - Lego: 2
  # Inventory by Name:
  # - Incredible Copper Bag: 3
  # - Synergistic Rubber Car: 2
  # - Aerodynamic Marble Computer: 3
  # - Synergistic Wooden Chair: 2
  def print_report products
    brands = count_by_brand products
    products = count_by_name products
    output ||= "Average Price: $#{average_price(products)}\n"
    output += "Inventory by Brand: "
    output += inventory_output brands
    output += "Inventory by Name: "
    output += inventory_output products
    output
  end
end
