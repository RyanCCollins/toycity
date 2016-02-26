require 'json'

# Easily calculate the percent difference by extending class numeric
class Numeric
  def percent_diff(n)
    (1 -self.to_f / n.to_f) * 100.0 
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
    $report = {:products => [], :brands => {}, :options => {}}
end

def start
  # You can use this to set options for the report.
  # Set products, brands
  set_options({:products => true, :brands => true, :headings => true })
  setup_files
  create_report
  puts $report
end

def set_options(options)
  $report[:options] = options
end

def create_report
  print_data
end

def print_data
  if $report[:options][:products] == true
    $output += make_headings('products')
    $output += make_products_section
  end
  if $report[:options][:brands] == true
    $output += make_headings('brands')
    $output += make_brand_section
  end
end

def make_headings(section)
  if should_make_headings?
    # Print headings as long as there are products and brands
    if section == 'products'
      return product_header
    end
    if section == 'brands'
      return brand_header
    end
  end
end

# If the headings option is set, then return true.
def should_make_headings?
  return $report[:options][:headings]
end

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
def make_products_section
  products = Array.new()
  $items.each do |item|
   products.push(construct_product(item))
  end
  return products.to_s
end

def construct_product(item)
    # Define and initialize our varaiables
    $report[:products][item][:title] = item["title"]
    $report[:products][item][:purchases] = item["purchases"]
    $report[:products][item][:total_purchases] = item["purchases"].length
    $report[:products][item][:full_price] = item["full-price"].to_f
    total_sales = 0
    
    # For each purchase, add to the total sales value.
    $report[:products][item][:purchases].each do |purchase|
      total_sales += purchase["price"]
    end
    
    $report[:products][item][:total_sales] = total_sales
    
    # Unless total_purchases is 0, calculate the average
    unless $report[:products][item][:total_purchases] == 0
      $report[:products][item][:average_price] = total_sales / $report[:products][item][:total_purchases]
      # Calculate the full price using the formula defined
        # in the class Numeric extension above
      $report[:products][item][:discount] = $report[:products][item][:average_price].percent_diff($report[:products][item][:full_price])
    end
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
    unless $report[:brands][brand_name]
      $report[:brands][brand_name][:name] = brand_name
      $report[:brands][brand_name][:product_name] = item["title"].split(' ')[1..-1].join(' ')
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