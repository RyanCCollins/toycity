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
  return header # I know you don't have to call return, but I think it's easier to read.
end

# Return the date now in standard format
def date_now
  return Time.now.strftime("%m/%d/%Y")
end


# Print "Sales Report" in ascii art
  # (Note): Will return then print in the print_data method
def report_header
  header = "____  ____  _     _____ ____    ____  _____ ____  ____  ____  _____\n" +
           "/ ___\/  _ \/ \   /  __// ___\  /  __\/  __//  __\/  _ \/  __\/__ __\\n"+
           "|    \| / \|| |   |  \  |    \  |  \/||  \  |  \/|| / \||  \/|  / \\n" +
           "\___ || |-||| |_/\|  /_ \___ |  |    /|  /_ |  __/| \_/||    /  | |\n" +
           "\____/\_/ \|\____/\____\\____/  \_/\_\\____\\_/   \____/\_/\_\  \_/ \n" 
  return header
end

# Print "Brands" in ascii art
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

def generate_product_section(item) #Takes an product hash and output the contents
    output = product_header
    output += "#{item.title}\n"
    output += "************************************"
    output += "Full Retail Price    |    $#{item.full_price}\n"
    output += "Total Purchases      |    #{item.total_purchases}\n"
    output += "Total Sales          |    $#{item.total_sales}"
    output +=  "Average Price        |    $#{item.average_price}"
    output += "Percentage Discount  |    #{item.discount.round(2)}%"
    output += "\n" # New Line
    return output
end

def parse_product(item)
    # Define and initialize our varaiables
    product = {}
    purchases = item["purchases"]
    product[:title] = item["title"]
    product[:purchases] = purchases
    product[:total_purchases] = item["purchases"].length
    product[:full_price] = item["full-price"].to_f
    total_sales = 0
    
    
    # For each purchase, add to the total sales value.
    purchases.each do |purchase|
      total_sales += purchase["price"]
    end
    
    product[:total_sales] = total_sales
    
    # Unless total_purchases is 0, calculate the average
    unless product[:total_purchases] == 0
      product[:average_price] = total_sales / product[:total_purchases]
      # Calculate the full price using the formula defined
        # in the class Numeric extension above
      product[:discount] = product[:average_price].percent_diff(product[:full_price])
    end
  return product
end

def parse_brand(item, report)
  brand = {}
  brand_name = item["brand"]
  
  total_sales = item["purchases"].length
    
  # Loop through the purchases and add them up to calculate total_revenue
  total_revenue = 0
  item["purchases"].each { |a| total_revenue += a["price"] }

  #Unless the brand already exists in the hash, initialize a new item
  unless brand_exists?(brand_name, report)
    brand[:name] = brand_name
    brand[:product_name] = item["title"].split(' ')[1..-1].join(' ')
    brand[:total_sales] = total_sales
    brand[:count] = 1
    brand[:average_price] = total_revenue / total_sales
    brand[:stock] = item["stock"]
  else
    # If the brand already exists, update the items
    brand[:count] += 1
    brand[:total_sales] += total_sales
    brand[:total_revenue] += total_revenue
    brand[:average_price] = brand[:total_revenue] / total_sales
    brand[:stock] += stock
  end
  return brand
end

#Check if a brand exists in a given report
def brand_exists?(brand_name, report)
  report[:brands].each do |brand| 
    return brand[:brand_name] == brand_name ? true : false
  end
  return false
end

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
def make_products_section

end

def generate_brand_section(brands)
    #For each brand in the hash, loop and print the results
  brands.each do |brand, data|
    output = "#{data[:name]}\n"
    output += "************************************"
    output += "Count          |   #{data[:count]}\n" # It is ambiguous whether you are looking for the number of types of toys for the brand, 
    output += "Total Stock    |   #{data[:stock]}\n" # or the stock of toys for that brand
    output += "Average Price  |   $#{data[:average_price].round(2)}\n"
    output += "Total Revenue  |   $#{data[:total_revenue].round(2)}\n\r"
  end
  return output
end


def generate_report_data(items)
  report = {:products => [], :brands => []}
  items.each do |item|
    
    report[:products].push(parse_product(item))
    report[:brands].push(parse_brand(item, report))
    puts report
  end
    return report
end

# Return headings as long as the option to print headings is on
def make_headings(section)
  if should_make_headings?
    if section == 'report'
      return report_header
    end
    if section == 'products'
      return product_header
    end
    if section == 'brands'
      return brand_header
    end
  end
  return "" # Return an empty string if no conditions are hit
end

# If the headings option is set, then return true.
def should_make_headings?
  return $options[:headings]
end

def print_data
  output = ""
  output += make_headings('report')
  if $report[:options][:products] == true
    output += make_headings('products')
    output += make_products_section
  end
  if $report[:options][:brands] == true
    output += make_headings('brands')
    output += make_brand_section
  end
  return output
end

# Output the report to the file specified in target
  # Defined with ! because it is overwriting a file
def output_report!(output)
  File.open($report_file) { |file| file.write(output)}
end

def create_report!(items, options = {:products => true, :brands => true, :headings => true })
  $options = options
  generate_report_data(items)
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
  # Store the "options" hash globally
  $options = {}
end

# Start the program running
def start
  # You can use this to set options for the report.
    # Set products, brands and headings as boolean values
    # Defaults to true for each
  setup_files
  create_report!($items, {:products => true, :brands => true, :headings => true })
end

start