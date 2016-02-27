require 'json'

# Easily calculate the percent difference by extending class numeric
class Numeric
  def percent_diff(n)
    (1 -self.to_f / n.to_f) * 100.0 
  end
end

# Return the date now in standard format
def date_now
  return Time.now.strftime("%m/%d/%Y")
end

# Construct headers for the various sections
def product_header
  header = "\n" + date_now +
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

# Print "Sales Report" in ascii art
  # (Note): Will return then print in the print_data method
def report_header
  header = "" + "\n" + date_now + "\n" +
    " _______  _______  _        _______  _______  \n" + 
    "(  ____ \(  ___  )( \      (  ____ \(  ____ \ \n" +
    "| (    \/| (   ) || (      | (    \/| (    \/ \n" +
    "| (_____ | (___) || |      | (__    | (_____  \n" +
    "(_____  )|  ___  || |      |  __)   (_____  ) \n" +
    "      ) || (   ) || |      | (            ) | \n" +
    "/\____) || )   ( || (____/\| (____/\/\____) | \n" +
    "\_______)|/     \|(_______/(_______/\_______) \n" +
    "\n" +                                             
    " _______  _______  _______  _______  _______ _________ \n" +
    "(  ____ )(  ____ \(  ____ )(  ___  )(  ____ )\__   __/ \n" +
    "| (    )|| (    \/| (    )|| (   ) || (    )|   ) (    \n" +
    "| (____)|| (__    | (____)|| |   | || (____)|   | |    \n" +
    "|     __)|  __)   |  _____)| |   | ||     __)   | |    \n" +
    "| (\ (   | (      | (      | |   | || (\ (      | |    \n" +
    "| ) \ \__| (____/\| )      | (___) || ) \ \__   | |    \n" +
    "|/   \__/(_______/|/       (_______)|/   \__/   )_(    \n"
    # I know that you don't need to call return, but I think it makes the intention more clear
    return header 
end

# Returns "Brands" in ascii art
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

#Takes a report array returns output of the products
def make_products_section(report)
  products = report[:products]
  output = ""
  products.each do |product|
    output += "#{product[:title]}\n"
    output += "************************************\n"
    output += "Full Retail Price    |    $#{product[:full_price]}\n"
    output += "Total Purchases      |    #{product[:total_purchases]}\n"
    output += "Total Sales          |    $#{product[:total_sales]}\n"
    output +=  "Average Price        |    $#{product[:average_price]}\n"
    output += "Percentage Discount  |    #{product[:discount].round(2)}%"
    output += "\n" # New Line
  end
  return output
end

# Parse the product data and return it in usable format
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
  # Loop through the purchases and add them up to calculate total_revenue
  total_revenue = 0
  item["purchases"].each { |a| total_revenue += a["price"] }

  brand[:name] = item["brand"]
  brand[:total_sales] = item["purchases"].length
  brand[:total_revenue] = total_revenue
  brand[:count] = 1
  brand[:average_price] = total_revenue / item["purchases"].length
  brand[:stock] = item["stock"]
  return brand
end

def update_brand!(report, item)
  total_revenue = 0
  item["purchases"].each { |a| total_revenue += a["price"] }
  report[:brands].each do |brand|
    if brand["name"] == item["name"]
      brand[:count] += 1
      brand[:total_sales] += item["purchases"].length
      brand[:total_revenue] += total_revenue
      brand[:average_price] = brand[:total_revenue] / brand[:total_sales]
      brand[:stock] += item["stock"]
    end
  end
  return report
end

#Check if a brand exists in a given report
def brand_exists?(brand_name, report)
  report[:brands].each do |brand|
    return brand[:name] == brand_name
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

def make_brand_section(report)
    #For each brand in the hash, loop and print the results
  brands = report[:brands]
  puts brands
  output = ""
  brands.each do |brand|
    output += "#{brand[:name]}\n"
    output += "************************************\n"
    output += "Count          |   #{brand[:count]}\n" # It is ambiguous whether you are looking for the number of types of toys for the brand, 
    output += "Total Stock    |   #{brand[:stock]}\n" # or the stock of toys for that brand
    output += "Average Price  |   $#{brand[:average_price].round(2)}\n"
    output += "Total Revenue  |   $#{brand[:total_revenue].round(2)}\n\r"
    output += "\n"
  end
  return output
end

def generate_report_data(items)
  report = {:products => [], :brands => []}
  items.each do |item|
    report[:products].push(parse_product(item))
    
    unless brand_exists?(item["brand"], report)
      report[:brands].push(parse_brand(item, report))
    else
      report = update_brand!(report, item)
    end
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

def compile_output(report)
  output = ""
  output += make_headings('report')
  if $options[:products] == true
    output += make_headings('products')
    output += make_products_section(report)
  end
  if $options[:brands] == true
    output += make_headings('brands')
    output += make_brand_section(report)
  end
  return output
end

# Output the report to the file specified in target
  # Defined with ! because it is overwriting a file
def output_report!(output)
  $report_file.write(output)
end

def create_report!(items, options = {:products => true, :brands => true, :headings => true })
  $options = options #Set the global options value.
  report = generate_report_data(items)
  output_report!(compile_output(report))
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

