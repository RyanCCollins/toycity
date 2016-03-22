module Analyzable
  # count_by_brand(*brands)
  # @params [Product]
  # @return { :brand_name => count }
  #
  # ====== Example
  # Analyzable::count_by_brand(Product.all)
  # #=> {"Lego"=>3, "Fisher-Price"=>2, "Nintendo"=>1, "Crayola"=>2, "Hasbro"=>2}
  def count_by_brand(*products)
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
  def count_by_name(*products)
  end
  # average_price
  # @params [Product]
  # @return average_price
  def average_price()
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
  def print_report
  end
end
