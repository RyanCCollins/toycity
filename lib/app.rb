require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

# Easily calculate the percent difference by extending class numeric
  # C'mon, I had do use a bit of the ruby OOP magic for this project :)
class Numeric
  def percent_diff(n)
    (1 -self.to_f / n.to_f) * 100.0 
  end
end

# Print the date in month, day, year format
  # and the Products header
puts Time.now.strftime("%m/%d/%Y")
puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price

  # Label the items hash for easy reference
  items = products_hash["items"] 

  items.each do |item|
    # Define and initialize our varaiables
    purchases = item["purchases"]
    total_purchases = purchases.length
    full_price = item["full-price"].to_f
    total_sales = 0
  
    # For each purchase, add to the total sales value.
    purchases.each do |purchase|
      total_sales += purchase["price"]
    end
  
    # Unless total_purchases is 0, calculate the average
    unless total_purchases == 0
      average_price = total_sales / total_purchases
      # Calculate the full price using the formula defined
        # in the class Numeric extension above
      discount = average_price.percent_diff(full_price)
    end
  
    puts "#{item["title"]}"
    puts "************************************"
    puts "Full Retail Price    |    $#{full_price}"
    puts "Total Purchases      |    #{total_purchases}"
    puts "Total Sales          |    $#{total_sales}"
    puts "Average Price        |    $#{average_price}"
    puts "Percentage Discount  |    #{discount.round(2)}%"
    puts "\n" # New Line
  end

# Print the Brands header
puts " _                         _     "
puts "| |                       | |    "
puts "| |__  _ __ __ _ _ __   __| |___ "
puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
puts "| |_) | | | (_| | | | | (_| \\__ \\"
puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
puts

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total revenue of all the brand's toy sales combined

  brands = {}
  
  items.each do |item|
    brand_name = item["brand"]
    
    # Remove the the brand name and add the toy title
    product_name = item["title"].split(' ')[1..-1].join(' ')
    price = item["full_price"]
  
    total_sales = item["purchases"].length
    stock = item["stock"]
    
    # Loop through the purchases and add them up to calculate total_revenue
    total_revenue = 0
    item["purchases"].each { |a| total_revenue += a["price"] }

    #Unless the brand already exists, initialize a new item
    unless brands[brand_name]
      brands[brand_name] = {}
      brands[brand_name][:name] = brand_name
      brands[brand_name][:total_sales] = total_sales
      brands[brand_name][:count] = 1
      brands[brand_name][:average_price] = total_revenue / total_sales
      brands[brand_name][:total_revenue] = total_revenue
      brands[brand_name][:stock] = stock
    else
      # If the brand already exists, update the items
      brands[brand_name][:count] += 1
      brands[brand_name][:total_sales] += total_sales
      brands[brand_name][:total_revenue] += total_revenue
      brands[brand_name][:average_price] = brands[brand_name][:total_revenue] / brands[brand_name][:total_sales]
      brands[brand_name][:stock] += stock
    end
  end
  
  #A For each brand in the hash, loop and print the results
  brands.each do |brand, data|
    puts "#{data[:name]}"
    puts "************************************"
    puts "Count          |   #{data[:count]}" # It is ambiguous whether you are looking for the number of types of toys for the brand, 
    puts "Total Stock    |   #{data[:stock]}" # or the stock of toys for that brand
    puts "Average Price  |   $#{data[:average_price].round(2)}"
    puts "Total Revenue  |   $#{data[:total_revenue].round(2)}\n\r"
  end

