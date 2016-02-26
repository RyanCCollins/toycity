require 'json'

# Easily calculate the percent difference by extending class numeric
class Numeric
  def percent_diff(n)
    (1 -self.to_f / n.to_f) * 100.0 
  end
end

# Note, I included this in order to fill the requirements of
# Using semantic methods.  I realize that there are builtin methods for doing this.
class String 
  def is_empty? 
    return self.length == 0
  end
end

# Print the date in month, day, year format
# and the Products header
def product_header
  header = date_now +
  "\n" +
  "                     _            _       \n" +
  "                    | |          | |      \n"  +
  " _ __  _ __ ___   __| |_   _  ___| |_ ___ \n" +
  "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|\n" +
  "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\\n" +
  "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n" +
  "| |                                       \n" +
  "|_|                                       \n"
  return header
end

def date_now
  return Time.now.strftime("%m/%d/%Y")
end

def brand_header
  # Return the Brands header
  header = " _                         _     \n" +
  "| |                       | |    \n" +
  "| |__  _ __ __ _ _ __   __| |___ \n" +
  "| '_ \\| '__/ _` | '_ \\ / _` / __|\n" +
  "| |_) | | | (_| | | | | (_| \\__ \\\n" +
  "|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n"
  return header
end

# Get path to products.json, read the file into a string,
# and transform the string into a usable hash
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file) # Defined in global scope
    $report_file = File.new("report.txt", "w+") # Defined report file in global scope
    
    # Label the items hash for easy reference
    $items = $products_hash["items"]
    puts $items
end

def start
  $report = {:products => [], :brands => {}, :options => {products: true, brands: true}}
  setup_files
  create_report
end

def create_report
  print_data
end

def print_data
  make_products_section
  make_brand_section
end

def make_headings(options)
  output = ""
  if options[:products] == true
    output += product_header
  end
  if options[:brands] == true
    output += brand_header
  end
  
  unless output.is_empty?
    return output
  end
end

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
def make_products_section
  $items.each do |item|
    $report[:products].push(construct_product(item))
  end
end

def construct_product(item)
    # Define and initialize our varaiables
    product = Hash.new()
    product[:title] = item["title"]
    product[:total_purchases] = item["purchases"].length
    product[:full_price] = item["full-price"].to_f
    total_sales = 0
    
    # For each purchase, add to the total sales value.
    product[:purchases].each do |purchase|
      total_sales += purchase["price"]
    end
    
    product[:total_sales] = total_sales
    
    # Unless total_purchases is 0, calculate the average
    unless product[:total_purchases] == 0
      product[:average_price] = total_sales / product[:total_purchases]
      # Calculate the full price using the formula defined
        # in the class Numeric extension above
      product[:discount] = product[:average_price].percent_diff(full_price)
    end
    return product
end

def generate_product_section(item) #Takes an item hash and prints the contents
    output = product_header
    output += "#{item.title}"
    output += "************************************"
    output += "Full Retail Price    |    $#{item.full_price}"
    output += "Total Purchases      |    #{item.total_purchases}"
    output += "Total Sales          |    $#{item.total_sales}"
    output +=  "Average Price        |    $#{item.average_price}"
    output += "Percentage Discount  |    #{item.discount.round(2)}%"
    output += "\n" # New Line
    return output
end

def make_brand_section
  # For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total revenue of all the brand's toy sales combined

  $items.each do |item|
    brand_name = item["brand"]
    
    # Remove the the brand name and add the toy title

    price = item["full_price"]
  
    total_sales = item["purchases"].length
    stock = item["stock"]
    
    # Loop through the purchases and add them up to calculate total_revenue
    total_revenue = 0
    item["purchases"].each { |a| total_revenue += a["price"] }

    #Unless the brand already exists, initialize a new item
    unless brands[brand_name]
      $report[:brands][brand_name][:name] = brand_name
      $report[:product_name][brand_name][:product_name] = item["title"].split(' ')[1..-1].join(' ')
      $report[:brands][brand_name][:total_sales] = total_sales
      $report[:brands][brand_name][:count] = 1
      $report[:brands][brand_name][:average_price] = total_revenue / total_sales
      $report[:brands][brand_name][:total_revenue] = total_revenue
      $report[:brands][brand_name][:stock] = stock
    else
      # If the brand already exists, update the items
      $report[:brands][brand_name][:count] += 1
      $report[:brands][brand_name][:total_sales] += total_sales
      $report[:brands][brand_name][:total_revenue] += total_revenue
      $report[:brands][brand_name][:average_price] = brands[brand_name][:total_revenue] / brands[brand_name][:total_sales]
      $report[:brands][brand_name][:stock] += stock
    end
  end
  
end



def generate_brand_section(brands)
    #For each brand in the hash, loop and print the results
  brands.each do |brand, data|
    output = "#{data[:name]}"
    output += "************************************"
    output += "Count          |   #{data[:count]}" # It is ambiguous whether you are looking for the number of types of toys for the brand, 
    output += "Total Stock    |   #{data[:stock]}" # or the stock of toys for that brand
    output += "Average Price  |   $#{data[:average_price].round(2)}"
    output += "Total Revenue  |   $#{data[:total_revenue].round(2)}\n\r"
  end
  return output
end




start